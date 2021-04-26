<?php

require_once 'start/ini.php';
require_once 'lib/url.php';
require_once 'lib/xml.php';
require_once 'lib/html.php';

$layout
	->set('title','Über die Edition')
	->set('content',
		buildElement('h2','Korpus').
		buildElement('p','Das Korpus beinhaltet deutschsprachige Texte mit Bezug auf die „Messa da Requiem“ von Giuseppe Verdi und zu deren Erstaufführungen in den Jahren 1874–1878.').
		buildElement('p','Die maßgeblichen Kriterien für die Aufnahme sind:').
		buildElement('ol',
			buildElement('li','Bezug auf das Verdi-Requiem oder eine Aufführung desselben,').
			buildElement('li','Entstehung oder zeitlicher Bezug zwischen 1874 und 1878,').
			buildElement('li','verfasst in deutscher Sprache oder direkter Bezug zur deutschsprachigen Rezeption.')
		).
		buildElement('p','Es umfasst die folgenden Textsorten:').
		buildElement('ol',
			buildElement('li','Texte aus deutschsprachigen Musikfachzeitschriften.').
			buildElement('li','Texte aus deutschsprachigen Tageszeitungen; vorrangig Rezensionen, aber auch relevante Texte über das Umfeld der Aufführungen.').
			buildElement('li','Texte aus deutschsprachigen illustrierten Periodika.').
			buildElement('li','Theaterzettel und Anzeigen (exemplarisch).').
			buildElement('li','Private Briefe (teils nach 1878 verfasst).').
			buildElement('li','(Auto-)Biographische Texte (teils nach 1878 erschienen).').
			buildElement('li','Historiographische Texte (nach 1878, exemplarisch).').
			buildElement('li','Nicht-deutschsprachige Texte, sofern sie als Referenz für deutschsprachige Texte bedeutend sind.')
		).
		buildElement('h2','Texterfassung').
		buildElement('h3','Umbrüche').
		buildElement('ul',
			buildElement('li','Erfasst sind Seiten- und Spaltenumbrüche; Zeilenfall ist nur in Poesieformen und in Anzeigen dokumentiert.').
			buildElement('li','Spalten sind mit a, b, c usw. nummeriert, falls keine eigene Zählung vorliegt. Bei der Erfassung ist die Seitenzahl vorangestellt, z. B. 1a, 1b, 1c.').
			buildElement('li','Bei Umbrüchen innerhalb eines Wortes fällt der Bindestrich gesetzt; stattdessen steht in diesen Fällen die Umbruchmarke ohne Leerzeichen im Wort. Ansonsten sind beidseitig Leerzeichen gesetzt.')
		).
		buildElement('h3','Typographie').
		buildElement('ul',
			buildElement('li','Alle gängigen Hervorhebungsformen (Type, Größe, Laufweite, Gewicht, Neigung) sind erfasst.').
			buildElement('li','Geviertstriche [—] sind erhalten.').
			buildElement('li','Listensymbole und Autorenzeichen sind <i>in der Regel</i> mit einem passenden Unicode-Zeichen übertragen.')
		).
		buildElement('h3','Besonderheiten im Fraktursatz').
		buildElement('ul',
			buildElement('li','Sämtliche Ligaturen (ch, ck, tz usw.) sind aufgelöst.').
			buildElement('li','Das Lange s [ſ] ist zu [s] aufgelöst.').
			buildElement('li','Das Tironische Et [⁊] ist zu [et] aufgelöst.').
			buildElement('li','Das [I] ist zu [I] und [J] differenziert.').
			buildElement('li','Der Doppelbindestrich [⸗] ist zu einfachem Bindestrich [-] aufgelöst.').
			buildElement('li','Zwiebelfische (Antiqua innerhalb von Fraktur, insbes. è, ë usw. in Wörtern lateinischen Ursprungs) sind <i>in der Regel</i> erfasst.').
			buildElement('li','Majuskelumlaute (Ae, Oe, Ue) sind <i>in der Regel</i> nicht normalisiert.')
		).
		buildElement('h3','Orthographie, Normalisierung, Setzerfehler').
		buildElement('ul',
			buildElement('li','Alle t/th- oder s/ss/ß-Formen sowie alle c-/k-/z-Varianten bleiben wie im Original erhalten.').
			buildElement('li','Nur sehr ungewöhnliche oder eindeutig fehlerhafte Formen sind durch eine normalisierte bzw. korrekte Form ergänzt.').
			buildElement('li','Setzerfehler sind nach Möglichkeit auf Zeichenebene korrigiert und dokumentiert.')
		).
		buildElement('h3','Referenzen').
		buildElement('ul',
			buildElement('li','Es sind Bezüge zu Personen, Orten, Werken und Werkteilen, Datumsangaben, Produktionen und Aufführungen (hier: Ereignisse), Körperschaften (meist Zeitungen, aber auch Musikvereine) und anderen Texten erfasst.').
			buildElement('li','Die Bezüge sind durch Markup des Eigennamens im Text erfasst (bzw. der Umschreibung, wenn kein Eigenname vorliegt). Titel, Anrede und anschließende Satzzeichen sind dabei nicht eingeschlossen.').
			buildElement('li','Fehlerhafte Referenzen (z. B. Verwechselungen) sind dokumentiert und korrigiert.')
		).
		buildElement('h3','Anmerkungen').
		buildElement('p','Literaturbezüge, Bibelzitate und Worterklärungen sind nach Möglichkeit durch eine möglichst zeitgenössische Quelle belegt.').
		buildElement('p','Fremdsprachigen Redewendungen oder Ausdrücken von allgemeiner Bekanntheit ist eine Übersetzung angefügt.').
		buildElement('p','right','Torsten Roeder')
	)
	->cast();

?>