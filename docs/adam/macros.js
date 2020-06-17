remark.macros.scale = function (percentage) {
  var url = this;
  return '<img src="' + url + '" style="width: ' + percentage + '" />';
};

remark.macros['class'] = function(cl) {
  var url = this;
  return '<img src="' + url + '" class="' + cl + '" />';
};

remark.macros['gen'] = function(w, cl="") {
  var url = this;
  return '<img src="' + url + '" style="width: ' + w + '" class="' + cl + '" />';
};

remark.macros.scalev = function (percentage) {
  var url = this;
  return '<img src="' + url + '" style="height: ' + percentage + '" />';
};

remark.macros['genv'] = function(w, cl="") {
  var url = this;
  return '<img src="' + url + '" style="height: ' + w + '" class="' + cl + '" />';
};
