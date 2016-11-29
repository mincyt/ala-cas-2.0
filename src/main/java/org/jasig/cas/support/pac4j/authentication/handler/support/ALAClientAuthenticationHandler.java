/*
 * Licensed to Jasig under one or more contributor license
 * agreements. See the NOTICE file distributed with this work
 * for additional information regarding copyright ownership.
 * Jasig licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License.  You may obtain a
 * copy of the License at the following location:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.jasig.cas.support.pac4j.authentication.handler.support;

import java.security.GeneralSecurityException;
import javax.security.auth.login.FailedLoginException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.StringUtils;
import org.jasig.cas.authentication.BasicCredentialMetaData;
import org.jasig.cas.authentication.HandlerResult;
import org.jasig.cas.authentication.PreventedException;
import org.jasig.cas.authentication.AbstractAuthenticationHandler;
import org.jasig.cas.authentication.Credential;
import org.jasig.cas.authentication.principal.Principal;
import org.jasig.cas.authentication.principal.PrincipalResolver;
import org.jasig.cas.support.pac4j.authentication.principal.ClientCredential;
import org.pac4j.core.client.Client;
import org.pac4j.core.client.Clients;
import org.pac4j.core.context.J2EContext;
import org.pac4j.core.context.WebContext;
import org.pac4j.core.profile.UserProfile;
import org.springframework.webflow.context.ExternalContextHolder;
import org.springframework.webflow.context.servlet.ServletExternalContext;
import au.org.ala.cas.UserCreator;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;
import java.util.regex.Pattern;
import au.org.ala.cas.AttributeParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This handler authenticates the client credentials : it uses them to get the user profile returned by the provider
 * for an authenticated user.
 *
 * @author Martin Bohun
 * @since 3.5.0
 */
@SuppressWarnings("unchecked")
public final class ALAClientAuthenticationHandler extends AbstractAuthenticationHandler {

    protected final Logger logger = LoggerFactory.getLogger(this.getClass());

    static final Pattern EMAIL_PATTERN  = Pattern.compile("^.+@.+\\..+$");

    /**
     * The clients for authentication.
     */
    @NotNull
    private final Clients clients;

    @NotNull
    private final PrincipalResolver principalResolver;

    @NotNull
    private final UserCreator userCreator;

    /**
     * Define the clients.
     *
     * @param theClients The clients for authentication
     */
    public ALAClientAuthenticationHandler(final Clients theClients,
					  final PrincipalResolver principalResolver,
					  final UserCreator userCreator) {
        this.clients = theClients;
	this.principalResolver = principalResolver;
	this.userCreator = userCreator;
    }

    @Override
    public boolean supports(final Credential credential) {
        return credential != null && ClientCredential.class.isAssignableFrom(credential.getClass());
    }

    @Override
    public HandlerResult authenticate(final Credential credential) throws GeneralSecurityException, PreventedException {
        final ClientCredential clientCredentials = (ClientCredential) credential;
        logger.debug("clientCredentials : {}", clientCredentials);

        final String clientName = clientCredentials.getCredentials().getClientName();
        logger.debug("clientName : {}", clientName);

        // get client
        final Client<org.pac4j.core.credentials.Credentials, UserProfile> client = this.clients.findClient(clientName);
        logger.debug("client : {}", client);

	// web context
	final ServletExternalContext servletExternalContext = (ServletExternalContext) ExternalContextHolder.getExternalContext();
	final HttpServletRequest request = (HttpServletRequest) servletExternalContext.getNativeRequest();
	final HttpServletResponse response = (HttpServletResponse) servletExternalContext.getNativeResponse();
	final WebContext webContext = new J2EContext(request, response);

        // get user profile
        final UserProfile userProfile = client.getUserProfile(clientCredentials.getCredentials(), webContext);
        logger.debug("userProfile : {}", userProfile);

        if (userProfile != null && StringUtils.isNotBlank(userProfile.getTypedId())) {
            clientCredentials.setUserProfile(userProfile);

	    final String email = AttributeParser.lookup("email", userProfile);
	    logger.debug("email : {}", email);

	    if (email==null || !EMAIL_PATTERN.matcher(email).matches()) {
		logger.debug("Invalid email : {}, authentication aborted!", email);
		throw new FailedLoginException("No email address found; email address is required to lookup (and/or create) ALA user!");
	    }

	    //NOTE: just in case social media gave us email containing Upper case letters
	    final String emailAddress = email.toLowerCase();
	    final Credential alaCredential = new Credential() {
		    public String getId() {
			return emailAddress;
		    }
		};

	    // get the ALA user attributes from the userdetails DB ("userid", "firstname", "lastname", "authority")
	    Principal principal = this.principalResolver.resolve(alaCredential);
	    logger.debug("{} resolved principal: {}", this.principalResolver, principal);

	    // does the ALA user exist?
	    if (!ALAClientAuthenticationHandler.validatePrincipalALA(principal)) {
		// create a new ALA user in the userdetails DB
		logger.debug("user {} not found in ALA userdetails DB, creating new ALA user for: {}.", emailAddress, emailAddress);
		this.userCreator.createUser(userProfile); //TODO: we can check this for failed user creation, to be accurate

		// re-try (we have to retry, because that is how we get the required "userid")
		principal = this.principalResolver.resolve(alaCredential);
		logger.debug("{} resolved principal: {}", this.principalResolver, principal);
		if (!ALAClientAuthenticationHandler.validatePrincipalALA(principal)) {
		    // we failed to lookup ALA user (most likely because the creation above failed), complain, throw exception, etc.
		    throw new FailedLoginException("Unable to create ALA user for " + clientCredentials);
		}
	    }

            return new HandlerResult(this,
				     new BasicCredentialMetaData(credential), //TODO: credential or alaCredential?
				     principal);
        }

        throw new FailedLoginException("Provider did not produce profile for " + clientCredentials);
    }

    static boolean validatePrincipalALA(final Principal principal) {
	return (principal != null)
	    && (principal.getAttributes() != null)
	    && principal.getAttributes().containsKey("userid");
    }
}
