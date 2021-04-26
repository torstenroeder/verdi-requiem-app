<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';
require_once 'lib/typesetting.php';

$layout
	->set('title','JavaScript Test')
	->set('content',
		'<p>Die Herren <span class="widespace ">Ernst</span> und <span class="widespace ">Betz</span>, die Träger der <span class="italic">Solopartieen</span>, lösten aber ihre Aufgaben in durchaus würdiger Weise.</p>'.
		schoenerSperrsatz(
			'<p>Die Herren <span class="widespace "><a class="person" href="person?nym=ernst.heinrich" title="Person">Ernst</a></span> und <span class="widespace ">Betz</span>, die Träger der <span class="italic">Solopartieen</span>, lösten aber ihre Aufgaben in durchaus würdiger Weise.</p>'
		).
		schoenerSperrsatz(
			'<p>Die Herren <span class="widespace "><a class="person" href="person?nym=ernst.heinrich" title="Person">Ernst</a></span> und <span class="widespace "><a class="person" href="person?nym=betz.franz" title="Person">Betz</a></span>, die Träger der Solopartieen, lösten aber ihre Aufgaben in durchaus würdiger Weise.</p>'
		).
		schoenerSperrsatz(
			'<p>Die Frls. <span class="widespace "><a class="person" href="person?nym=lehmann.lilli" title="Person">Lehmann</a></span> und <span class="widespace "><a class="person" href="person?nym=brandt.marianne" title="Person">Brandt</a></span>, sowie die Herren <span class="widespace "><a class="person" href="person?nym=ernst.heinrich" title="Person">Ernst</a></span> und <span class="widespace "><a class="person" href="person?nym=betz.franz" title="Person">Betz</a></span>, die Träger der Solopartieen, lösten aber ihre Aufgaben in durchaus würdiger Weise.</p>'
		)
	)
	->cast();

?>