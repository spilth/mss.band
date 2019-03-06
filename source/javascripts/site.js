$(function() {
  $('#showChords').prop('disabled', true);

  $('#hideChords').click(function(event) {
    event.preventDefault();
    $('.chord').toggle();
    $('#chords').toggle();
    $('#showChords').prop('disabled', false);
    $('#hideChords').prop('disabled', true);
  });

  $('#showChords').click(function(event) {
    event.preventDefault();
    $('.chord').toggle();
    $('#chords').toggle();
    $('#showChords').prop('disabled', true);
    $('#hideChords').prop('disabled', false);
  });
});
