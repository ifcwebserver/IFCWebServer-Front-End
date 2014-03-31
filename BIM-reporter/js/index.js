<script type="text/javascript">
$(document).ready(function(){
$("#ifc_file").change(function()
{
var id=$(this).val();
var dataString = 'q=ifc_classes_in_model&f='+ id;
$("#q").html("<option>Loading...</option>");
$("#ifc_attributes").html("<option></option>");
$.ajax
({
type: "GET",url: "/ajax.rb",data: dataString,cache: false,success: function(html)
{
$("#q").html(html);
$("#model_info").html("<a href='/viewer1/?url=/dae/<%= $username%>/" + id.replace(".ifc",".dae") + "'><img width=250 src='/cache/<%= $username%>/" + id + "/" + id + ".png' />");
} 
});
});

$("#q").change(function()
{
var id=$(this).val();
$("#ifc_attributes").html("<option>Loading...</option>");
var dataString = 'q=classes_attributes&c=' + id + '&f='+ $("#ifc_file").val();
$.ajax
({
type: "GET",url: "/ajax.rb",data: dataString,cache: false,success: function(html)
{
$("#ifc_attributes").html(html);
} 
});
});
document.getElementById('ifc_attributes').ondblclick =function(){
document.getElementById('report_cols').value += $(this).val() + "|";
	var report_fields =document.getElementById('report_fields'); 
	report_fields.options[report_fields.length] =new Option($(this).val(), $(this).val());
};
});
function reset_selection(el)
{
  document.getElementById('report_cols').value="";
  var selected_classes = el.form.elements['report_fields'];
  for(var i=0, len=selected_classes.length; i<len; ++i)
  {
    selected_classes.options.remove(0);;
  }
};
</script>