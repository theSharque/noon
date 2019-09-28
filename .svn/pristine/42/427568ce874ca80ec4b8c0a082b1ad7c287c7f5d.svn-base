<?php

  $sape_articles = $sape_article->return_announcements();

  $url = $_SERVER['REQUEST_URI'];
  $articles = db_fetch_array( "SELECT id, title FROM article WHERE page = '$url'" );

  if( $sape_articles ) {
    echo '<h2>Статьи по теме</h2><br><br><div id=articles>';
    echo $sape_articles;
  } else {
    if( count( $articles ) ) {
      echo '<h2>Статьи по теме</h2><br><br><div id=articles>';
    }
  }

  if( count( $articles ) ) {
    foreach( $articles as $line ) {
      echo "<li><a href=/article.php?id={$line['id']}>{$line['title']}</a></li>";
    }
  }
  echo '</div>';
