<div id="header">
	<div id="navigation">
		<h4><a href=".">Startseite</a></h4>
		<ul>
			<li><a href="edition">Über die Edition</a></li>
			<!--<li><a href="system">System</a></li>-->
		</ul>
		<h4>Suche</h4>
		<form id="searchbox" method="GET" action="search.php">
			<input name="term" id="term" type="text" maxlength="30" value=""/><button type="submit">&gt;</button>
		</form>
		<h4>Register</h4>
		<ul>
			<li><a href="documents">Dokumente</a></li>
			<li><a href="events">Ereignisse</a></li>
			<li><a href="orgs">Körperschaften</a></li>
			<li><a href="persons">Personen</a></li>
			<!--<li><a href="authors">- Autoren</a></li>-->
			<!--<li><a href="concepts">Begriffe</a></li>-->
			<li><a href="opuses">Werke</a></li>
			<li><a href="places">Orte</a></li>
		</ul>
		<h4>Spezialseiten</h4>
		<ul>
			<li><a href="documentsImages">Abbildungen</a></li>
			<li><a href="biblio">Bibliographie</a></li>
		</ul>
	</div>
	<h1><?php $this->cast('title') ?></h1>
</div>
<div id="content">
	<?php $this->cast('content') ?>
</div>
<div id="footer">
</div>
