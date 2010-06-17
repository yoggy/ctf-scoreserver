function on_edit(id){
  $.ajax({
     type: "POST",
     url: "load",
     data: "id="+id,
     success: function(res){
       $('#edit_id').val(res.id);
       $('#edit_point').val(res.point);
       $('#edit_abstract').val(res.abstract);
       $('#edit_status').val(res.status);
       $('#edit_detail').html(res.detail);
       $('#edit_answer').val(res.answer);
       alert("Challenge data was loaded into the following form. Please push the save button after you edit the form. ");
     }
   });
}

function on_delete(id){
  if (confirm("delete challenge? (id="+ id + ")")) {
    $('#delete_id').attr("value", id);
    $('#delete_form').submit();
  }
}

