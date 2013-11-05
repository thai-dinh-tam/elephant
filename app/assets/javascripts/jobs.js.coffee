$ ->

  $('.custom-select').customSelect()

  if (!window.matchMedia || !window.matchMedia("(max-device-width: 1024px)").matches)
    $('.job-type-description-target').tooltip()
    $('.tooltip-info').tooltip()
    $('.unit-tooltip').tooltip()

  $('.unitsSelect').customSelect()

  $('.job-start-date').datepicker()


  $('.job-start-date').change ->
    $.ajax '/jobs/' + $(this).attr("id").replace("job_start_date_", "") + '?start_date=' + $(this).val(), type: 'put', dataType: 'script'
    if $('#job_time_content').length() > 0
      $('#job_time_content').addClass 'hidden'
      $('#job_time_loader').removeClass 'hidden'


  last_selected_item = null
  focusevent = (event, ui) ->
    if last_selected_item != null
      $('.item_' + last_selected_item.id).removeClass('ui-state-hover')
    selected_item = $('.item_' + ui.item.id)
    selected_item.addClass('ui-state-hover')
    last_selected_item = ui.item

  $('#new_member_name').autocomplete
    source: $('#new_member_name').data('autocomplete-source')
    focus: focusevent
    select: (event, ui) ->
      if ui.item.id > 0
        $("#new_member_name").val(ui.item.label)
      $("#new_member_id").val(ui.item.id)
  #$("#new_member_form").submit()

  $('#new_note_name').autocomplete
    source: $('#new_note_name').data('autocomplete-source')
    focus: focusevent
    select: (event, ui) ->
      if ui.item.id > 0
        $("#new_note_name").val(ui.item.label)
        $("#new_note_name_id").val(ui.item.id)




  $('.job-member-list-item').live "mouseenter", ->
    $(this).find('.job-member-edit-button').css('visibility', 'visible')
    $(this).find('.delete-button-small').css('visibility', 'visible')

  $('.job-member-list-item').live "mouseleave", ->
    $(this).find('.job-member-edit-button').css('visibility', 'hidden')
    $(this).find('.delete-button-small').css('visibility', 'hidden')

  $('.custom-data-input').click ->
    $(this).select()

  $('.custom-data-input').keyup ->
    conversion = $(this).closest('.job-field-div').find('.job-field-conversion')
    if conversion
      conversion.remove()

  $('.custom-data-input').change ->
    conversion = $(this).closest('.job-field-div').find('.job-field-conversion')
    if conversion
      conversion.remove()
    $.ajax '/dynamic_fields/' + $(this).attr("id").replace("dynamic_field_", "") + '?value=' + $(this).val() + "&job=" + $(this).attr('data-job'), type: 'put', dataType: 'script'

  $('.unitsSelect').change ->
    conversion = $(this).closest('.job-field-div').find('.job-field-conversion')
    if conversion
      conversion.remove()
    $.ajax '/dynamic_fields/' + $(this).attr("id").replace("dynamic_field_unit_", "") + '?unit=' + $(this).val(), type: 'put', dataType: 'script'


  $('.job-tray-toggle').click ->
    $('.job-tray-toggle').closest('li').removeClass 'active'
    $('.job-tray').addClass 'custom-data-closed'
    $(this).closest('li').addClass 'active'
    tray = $(this).attr('data-tray')
    $(".job-tray[data-tray=" + tray + "]").removeClass 'custom-data-closed'
    document.location.hash = tray;
    if $('.job-main-div').length > 0
      $('body').animate({scrollTop : $('.job-main-div').position().top - 70 }, 'fast')
    return false

  $('.job-tray-toggle').click ->
    if $(this).attr('data-tray') == "activity"
      $('#activity_list').hide()
      $('.activity-loading').removeClass 'hidden'
      $('.activity-loading').find('.loading').removeClass 'hidden'
      if $('.job-main-div').length > 0
        $.ajax '/activities?job_id=' + $('.job-main-div').attr("id").replace("job_", ""), type: 'get', dataType: 'script'
    if $(this).attr('data-tray') == "drilling-overview"
      $('#drilling_overview').find('.content').hide()
      $('.drilling-overview-loading').removeClass 'hidden'
      $('.drilling-overview-loading').find('.loading').removeClass 'hidden'
      $.ajax '/drilling_logs/' + $(this).attr('data-id') + "&section=drilling_overview", type: 'get', dataType: 'script'
    return false

  if document.location.hash != ''
    $(".job-tray-toggle[data-tray=" + document.location.hash.replace('#', '') + "]").trigger "click"

  #$('#add_failure').click ->
  #  $('#modal_popup').css('visibility', 'visible')
  #  $('#modal_popup').find('.modal-popup').css('margin-top', $('body').scrollTop() + 100)
  #  $('#modal_popup').height($(document).height() + 100)
  #  $('#modal_popup').find('.loading').removeClass 'hidden'


  $('.division-jobs-toggle').click ->
    $('.division-job-item').each ->
      if $(this).hasClass 'hidden'
        $(this).removeClass 'hidden'
      else
        $(this).addClass 'hidden'
    return false

#if $('#job_activities')
#  $.ajax '/activities' + '?job_id=' + $(this).val(), type: 'put', dataType: 'script'

  $('.expand-job-description').live "click", ->
    $(this).remove()
    $('.job-description-custom-data-div').css("max-height", 100000)
    return false





