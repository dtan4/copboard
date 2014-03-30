#= require jquery-2.1.0.min
#= require bootstrap

$('#analyzeBtn').click( ->
  $.getJSON('/analyze', { dir: $('#analyzeDir').val() }, (json) ->
    console.log json
  )
)
