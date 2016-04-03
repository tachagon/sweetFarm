$(document).ready(function () {
  $('.field_with_errors').addClass('has-error');
});

var option_province = function (target_id) {
  $.ajax({
      type: "GET",
      dataType: "json",
      url: "/provinces",
      success: function(data){
          var option = "";
          for (var i = 0; i < data.length; i++) {
              option += "<option value=\'" + data[i]["PROVINCE_ID"] + "\'>";
              option += data[i]["PROVINCE_NAME"] + "</option>";
          }
          document.getElementById(target_id).innerHTML = option;
      }
  });
}

var option_amphur = function (target_id, province_id) {
  var url = "/provinces/" + province_id + "/amphurs";
  $.ajax({
    type: "GET",
    dataType: "json",
    url: url,
    success: function(data){
      console.log(data);
      var option = "<option>เลือกอำเภอ</option>";
      for (var i = 0; i < data.length; i++) {
          option += "<option value=\'" + data[i]["AMPHUR_ID"] + "\'>";
          option += data[i]["AMPHUR_NAME"] + "</option>";
      }
      document.getElementById(target_id).innerHTML = option;
    }
  });
}

var option_district = function (target_id, province_id, amphur_id) {
  var url = "/provinces/" + province_id + "/amphurs/" + amphur_id + "/districts";
  $.ajax({
    type: "GET",
    dataType: "json",
    url: url,
    success: function(data){
      console.log(data);
      var option = "<option>เลือกตำบล</option>";
      for (var i = 0; i < data.length; i++) {
          option += "<option value=\'" + data[i]["DISTRICT_ID"] + "\'>";
          option += data[i]["DISTRICT_NAME"] + "</option>";
      }
      document.getElementById(target_id).innerHTML = option;
    }
  });
}

// user for create comma each 3 digit
$.fn.digits = function(){
    return this.each(function(){
        $(this).text( $(this).text().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") );
    })
}

