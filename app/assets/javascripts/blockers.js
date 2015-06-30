function removeBlocker(linkNode, event){
  event.preventDefault();
  var link = $(linkNode);
  var myFormGroup = link.parent().parent();
  myFormGroup.find("input[type=hidden]").val("true");
  myFormGroup.parent().hide();
}

function addBlocker($parent, formHTML){
  var new_id = new Date().getTime();
  var regexp = new RegExp("id_placeholder", "g");
  var content = formHTML.replace(regexp, new_id);
  $parent.append(content);
}


//event preventdefault
