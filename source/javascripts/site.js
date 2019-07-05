function hideChords() {
  $('.chord').hide();
  $('.tablature').hide();
  $('#chords').hide();
  $('#showChords').prop('disabled', false);
  $('#hideChords').prop('disabled', true);

  Cookies.set('lyricsOnly', 'true');
}

function showChords() {
  $('.chord').show();
  $('.tablature').show();
  $('#chords').show();
  $('#showChords').prop('disabled', true);
  $('#hideChords').prop('disabled', false);

  Cookies.set('lyricsOnly', 'false');
}

function showGuitar() {
  $('#guitar').show();
  $('#ukulele').hide();
  $('#showGuitar').prop('disabled', true);
  $('#showUkulele').prop('disabled', false);

  Cookies.set('diagrams', 'guitar');
}

function showUkulele() {
  $('#guitar').hide();
  $('#ukulele').show();
  $('#showGuitar').prop('disabled', false);
  $('#showUkulele').prop('disabled', true);

  Cookies.set('diagrams', 'ukulele');
}

$(function() {
  if (Cookies.get('diagrams') === 'ukulele') {
    showUkulele();
  } else {
    showGuitar();
  }

  if (Cookies.get('lyricsOnly') === 'true') {
    hideChords();
  } else {
    showChords();
  }

  $('#hideChords').click(function(event) {
    event.preventDefault();

    hideChords();
  });

  $('#showChords').click(function(event) {
    event.preventDefault();

    showChords();
  });

  $('#showGuitar').click(function(event) {
    event.preventDefault();

    showGuitar();
  });

  $('#showUkulele').click(function(event) {
    event.preventDefault();

    showUkulele();
  });
});
