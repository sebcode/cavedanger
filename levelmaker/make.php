#!/usr/bin/env php
<?php

$d = new DOMDocument;
$d->load($argv[1]);

$x = new DOMXPath($d);

foreach ($x->evaluate('//*[local-name() = "path"]') as $n) {
	parseData($n->getAttribute('d'));
}

function parseData($d)
{
	$oldx = -1;
	$oldy = -1;
	
	$startx = -1;
	$starty = -1;

	$relative = true;

	$data = explode(' ', $d);

	foreach ($data as $pos) {
		if ($pos == 'M') {
			$relative = false;
			continue;
		}

		if ($pos == 'm') {
			$relative = true;
			continue;
		}

		if (strpos($pos, ',') !== false) {
			list($x, $y) = explode(',', $pos);

			if ($startx == -1 && $starty == -1) {
				//echo '// float startx = ' . $x . ";\n";
				//echo '// float starty = ' . $y . ";\n";
				$startx = $x;
				$starty = $y;
			} else if ($relative) {
				$x = $oldx + $x;
				$y = $oldy + $y;
			}
	
			if ($oldx != -1 && $oldy != -1) {
				gencode($oldx, $oldy, $x, $y);
			}

			$oldx = $x;
			$oldy = $y;
		}
	}

	gencode($oldx, $oldy, $startx, $starty);
}

function gencode($x1, $y1, $x2, $y2)
{
	// translate coordinate system
	$y1 = 1024 - $y1;
	$y2 = 1024 - $y2;
	
	echo 'levBox.SetAsEdge(b2Vec2((float)'.$x1.'/PTM_RATIO, (float)'.$y1.'/PTM_RATIO), b2Vec2((float)'.$x2.'/PTM_RATIO, (float)'.$y2.'/PTM_RATIO));' . "\n";
	echo 'levBody->CreateFixture(&levBox, 0);' . "\n";
}

