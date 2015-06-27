function removeTask(linkNode){
  var link = $(linkNode);
  var myFormGroup = link.parent().parent();
  myFormGroup.find("input[type=hidden]").val("true");
  myFormGroup.parent().hide();
}

function addTask($parent, formHTML){
  var new_id = new Date().getTime();
  var regexp = new RegExp("id_placeholder", "g");
  var content = formHTML.replace(regexp, new_id);
  $parent.append(content);
}
