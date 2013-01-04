$ ->

  $('#client_name').autocomplete
    source: $('#client_name').data('autocomplete-source')
    select: (event, ui) ->
      $("#client_name").val(ui.item.label)
      $("#client_id").val(ui.item.id)


  $('#custom_data_toggle').live "click", ->
    if $('#custom_data').css("display") == "none"
      $('#custom_data').css "display", "block"
    else
      $('#custom_data').css "display", "none"
    return false

  $('#close_modal').live "click", ->
    $('#modal_popup').css "visibility", "hidden"
    $('#modal_popup').find(".modal-content").children().remove()
    $('#modal_popup').height(0)


  $('#new_field_link').click ->
    if $('#job_district_id').val() != ''
      $(this).attr 'href', "/fields/new" + '?district_id=' + $('#district_id').val()
    else
      alert('Select a District First')

  $('#new_well_link').click ->
    if $('#job_field_id').val() != ''
      $(this).attr 'href', "/wells/new" + '?field_id=' + $('#job_field_id').val()
    else
      alert('Select a Field First')

  if $('#job_district_id').val() == ''
    $('#job_field_id').attr "disabled", "disabled"
    $('#job_field_id').css "opacity", ".3"

  if $('#job_well_id').val() == ''
    $('#job_well_id').attr "disabled", "disabled"
    $('#job_well_id').css "opacity", ".3"

  if $('#job_segment_id').val() == ""
    $('#job_segment_id').attr "disabled", "disabled"
    $('#job_segment_id').css "opacity", ".3"

  if $('#job_product_line_id').val() == ""
    $('#job_product_line_id').attr "disabled", "disabled"
    $('#job_product_line_id').css "opacity", ".3"

  if $('#job_job_template_id').val() == ""
    $('#job_job_template_id').attr "disabled", "disabled"
    $('#job_job_template_id').css "opacity", ".3"

  $('#job_division_id').change ->
    $('#job_segment_id').attr "disabled", "disabled"
    $('#job_segment_id').css "opacity", ".3"
    $('#job_product_line_id').attr "disabled", "disabled"
    $('#job_product_line_id').css "opacity", ".3"
    $('#job_job_template_id').attr "disabled", "disabled"
    $('#job_job_template_id').css "opacity", ".3"
    $('#job_description').empty()

    if $('#job_division_id').val() != ''
      $.ajax '/divisions?division_id=' + $('#job_division_id').val(), dataType: 'script'

  $('#job_segment_id').change ->
    $('#job_product_line_id').attr "disabled", "disabled"
    $('#job_product_line_id').css "opacity", ".3"
    $('#job_job_template_id').attr "disabled", "disabled"
    $('#job_job_template_id').css "opacity", ".3"
    $('#job_description').empty()

    if $('#job_segment_id').val() != ''
      $.ajax '/segments?segment_id=' + $('#job_segment_id').val(), dataType: 'script'

  $('#job_product_line_id').change ->
    $('#job_job_template_id').attr "disabled", "disabled"
    $('#job_job_template_id').css "opacity", ".3"
    $('#job_description').empty()

    if $('#job_product_line_id').val() != ''
      $.ajax '/product_lines?product_line_id=' + $('#job_product_line_id').val(), dataType: 'script'

  $('#job_job_template_id').change ->
    $('#job_description').empty()
    if $('#job_job_template_id').val() != ''
      $.ajax '/job_templates/' + $('#job_job_template_id').val(), dataType: 'script'

  $('#district_id').change ->
    if $('#district_id').val() != ''
      $('#job_field_id').removeAttr("disabled")
      $('#job_field_id').css "opacity", "1"
      $.ajax '/fields?district_id=' + $('#district_id').val(), dataType: 'script'

  $('#job_field_id').change ->
    if $('#job_field_id').val() != ''
      $('#job_well_id').removeAttr("disabled")
      $('#job_well_id').css "opacity", "1"
      $('#job_well_id').attr "disabled", "disabled"
      $('#job_well_id').css "opacity", ".3"
      $.ajax '/wells?field_id=' + $('#job_field_id').val(), dataType: 'script'


  if $('#job_district_id').val()
    $.ajax '/fields?district_id=' + $('#job_district_id').val(), dataType: 'script'

