<%--
 TODO: add ALA licensing info
--%>
<!DOCTYPE html>

<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ala" uri="/tld/ala.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html lang="en">
    <fmt:setBundle basename="ala-cas-build" var="ala_cas_build" />
    <head>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<meta name="app.version" content="<fmt:message key="ala.cas.build.version" bundle="${ala_cas_build}"/>" />

	<title>ALA | Login Auth</title>

	<!-- Bootstrap -->
	<link href="css/bootstrap.min.css" rel="stylesheet" />

	<!-- FontAwesome -->
	<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" />

	<!-- ALA -->
	<link href="css/ala-cas.css" rel="stylesheet" />

	<!-- favicon -->
 	<link rel="apple-touch-icon" sizes="57x57" href="img/favicon/apple-icon-57x57.png">
 	<link rel="apple-touch-icon" sizes="60x60" href="img/favicon/apple-icon-60x60.png">
 	<link rel="apple-touch-icon" sizes="72x72" href="img/favicon/apple-icon-72x72.png">
 	<link rel="apple-touch-icon" sizes="76x76" href="img/favicon/apple-icon-76x76.png">
 	<link rel="apple-touch-icon" sizes="114x114" href="img/favicon/apple-icon-114x114.png">
 	<link rel="apple-touch-icon" sizes="120x120" href="img/favicon/apple-icon-120x120.png">
 	<link rel="apple-touch-icon" sizes="144x144" href="img/favicon/apple-icon-144x144.png">
 	<link rel="apple-touch-icon" sizes="152x152" href="img/favicon/apple-icon-152x152.png">
 	<link rel="apple-touch-icon" sizes="180x180" href="img/favicon/apple-icon-180x180.png">
 	<link rel="icon" type="image/png" sizes="192x192"  href="img/favicon/android-icon-192x192.png">
 	<link rel="icon" type="image/png" sizes="32x32" href="img/favicon/favicon-32x32.png">
 	<link rel="icon" type="image/png" sizes="96x96" href="img/favicon/favicon-96x96.png">
 	<link rel="icon" type="image/png" sizes="16x16" href="img/favicon/favicon-16x16.png">
 	<link rel="manifest" href="img/favicon/manifest.json">
 	<meta name="msapplication-TileColor" content="#ffffff">
 	<meta name="msapplication-TileImage" content="/ms-icon-144x144.png">
 	<meta name="theme-color" content="#ffffff">

  <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
    </head>
    <body id="cas">
	<!-- TODO: add ala:bannerMenu, etc. -->

  <!-- Navbar -->
  <nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
      <!-- Brand and toggle get grouped for better mobile display -->
      <div class="navbar-header">
        <a class="navbar-brand" href="https://www.ala.org.au">
          <img alt="Brand" class="img-responsive" src="img/supporting-graphic-element-flat.png">
          </a>
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand font-xsmall" href="https://www.ala.org.au">The Atlas Of Living Australia</a>
    </div>

      <!-- Collect the nav links, forms, and other content for toggling -->
      <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        <ul class="nav navbar-nav">
          <li >
            <a href="http://www.ala.org.au/about-the-atlas/contact-us/">
              Contact us
              <span class="sr-only">(current)</span>
            </a>
          </li>
          <li >
            <a href="http://www.ala.org.au/get-involved/">Get involved</a>
          </li>

          <li class="dropdown font-xsmall">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
              ALA Apps
              <span class="caret"></span>
            </a>
            <ul class="dropdown-menu" role="menu">
              <li><a href="http://spatial.ala.org.au/">Spatial portal</a></li>
              <li ><a href="http://biocache.ala.org.au/">Occurrence search</a></li>
              <li ><a href="http://fish.ala.org.au/">Fish map</a></li>
              <li ><a href="http://regions.ala.org.au/">Regions</a></li>
              <li ><a href="http://biocache.ala.org.au/explore/your-area">Explore your area</a></li>

              <li class="divider"></li>
              <li><a href="http://sightings.ala.org.au/">Record a sighting</a></li>
              <li><a href="http://collections.ala.org.au/">Collections</a></li>
              <li><a href="http://volunteer.ala.org.au/">DigiVol</a></li>
              <li><a href="https://fieldcapture.ala.org.au/merit">Fieldcapture</a></li>
              <li><a href="http://www.soils2satellites.org.au/">Soils to satellite</a></li>
              <li><a href="http://lists.ala.org.au/">Traits, species lists</a></li>
              <li><a href="http://phylolink.ala.org.au/">Phylolink</a></li>

              <li class="divider"></li>
              <li><a href="http://root.ala.org.au/">Community portals</a></li>
              <li><a href="http://dashboard.ala.org.au/">Dashboard</a></li>
              <li><a href="http://collections.ala.org.au/datasets">Datasets browser</a></li>
            </ul>
          </li>

        </ul>
        <form class="navbar-form navbar-left" role="search" action="http://bie.ala.org.au/search" method="get">
          <div class="form-group">
            <input type="text" class="form-control" placeholder="Search the Atlas"></div>
          <button type="submit" class="btn btn-primary">Search</button>
      </form>
        <small>
          <ul class="nav navbar-nav navbar-right">
            <!-- <li ><a href="#">My profile</a></li>
            <li ><a href="#">Login</a></li> -->

          <li class="dropdown font-xsmall">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
              User settings
              <span class="caret"></span>
            </a>
            <ul class="dropdown-menu" role="menu">
              <li><a href="/userdetails/myprofile">My profile</a></li>

              <li class="divider"></li>
              <li><a href="/cas/login">Login</a></li>
              <li><a href="/cas/logout">Logout</a></li>
              <li><a href="/userdetails/registration/createAccount">Register</a></li>
            </ul>
          </li>
          </ul>
        </small>
    </div><!-- /.navbar-collapse -->
</div><!-- /.container-fluid -->
</nav><!-- End Navbar -->

	<div id="content">
