$(document).ready(function(){
	// Not allow modify date inputs manually (only with calendar)
	$(document).on('focus','input.hasDatepicker',function(){
		$(this).blur();
	});

	// Disable end_date field when onwards input is checked
	$(document).on('click', 'input.onwards', function(){
		onwards(this);
	});

	onwards($('input#onwards'));
});

function onwards(checkbox){
  date_field = $('input.end_date', $(checkbox).closest('form, td'))
  if ($(checkbox).is(':checked')){
    date_field.attr('disabled',true);
    date_field.datepicker('destroy');
  } else {
    date_field.attr('disabled',false);
    date_field.datepicker(datepickerOptions);
  }
}
