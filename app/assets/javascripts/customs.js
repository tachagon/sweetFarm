$(document).ready(function () {
  $('.field_with_errors').addClass('has-error');
});

var option_province = function (target_id) {
  $.ajax({
      type: "GET",
      dataType: "json",
      url: "/provinces",
      success: function(data){
          var option = "<option value=''></option>";
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
      var option = "<option value=''>เลือกอำเภอ</option>";
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
      var option = "<option value=''>เลือกตำบล</option>";
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

// make a card announcement
var card_announcement = function (id, role, amount, price, province, amphur, district) {
  var html = "<div class=\"col-sm-6 col-md-4 col-lg-4\">";
  html += "<div class=\"thumbnail announcement-card\">";
  html += "<a href=\"announcements/" + id + "\" title=\"ดูรายละเอียดประกาศ\">";
  html += "<img src=\"http://placehold.it/320x150\">";
  html += "<div class=\"caption\">";
  html += "<h4 id=\"announcement-role-" + role + "\">";
  html += role + " " + amount + " ตัน ";
  html += "<small>(" + price + " บาท/ตัน)</small>";
  html += "</h4>";
  html += "<p>";
  html += "<i class=\"fa fa-map-marker\"></i> ";
  html += "จ." + province + ",";
  html += "อ." + amphur + ",";
  html += "ต." + district + "";
  html += "</p>";

  html += "<h4 class=\"pull-right\" id=\"announcement-result-price\">";
  html += "฿" + amount * price + "";
  html += "</h4>";

  html += "</div>";

  html += "<div class=\"ratings\">";
  html += "<div class=\"pull-right\">15 รีวิว</div>";
  html += "<p>";
  html += "<span><i class=\"fa fa-star\"></i></span>";
  html += "<span><i class=\"fa fa-star\"></i></span>";
  html += "<span><i class=\"fa fa-star\"></i></span>";
  html += "<span><i class=\"fa fa-star-half-o\"></i></span>";
  html += "<span><i class=\"fa fa-star-o\"></i></span>";
  html += "</p>";
  html += "</div>";


  html += "</a>";
  html += "</div>";

  html += "</div>";

  return html;
}

// get districe
var get_district = function (id) {
  var district = "default";
  $.ajax({
    url: '/district',
    type: 'GET',
    async: false,
    dataType: 'json',
    data: {id: id},
    success: function(data) {
      district = data;
    }
  });
  return district;
}

// get amphur form district
var get_amphur = function (id) {
  var amphur = "default";
  $.ajax({
    url: '/districtamphur',
    type: 'GET',
    async: false,
    dataType: 'json',
    data: {id: id},
    success: function(data) {
      amphur = data;
    }
  });
  return amphur;
}

// get province from district
var get_province = function (id) {
  var province = "default";
  $.ajax({
    url: '/districtprovince',
    type: 'GET',
    async: false,
    dataType: 'json',
    data: {id: id},
    success: function(data) {
      province = data;
    }
  });
  return province;
}


// get announcements
// var get_announcement = function (target_id, update_time) {

//   setInterval(function () {
//     $.getJSON('/announcements.json', function (data) {
//       var html = "";
//       for (var i = 0; i < data.length; i++) {
//         var id = data[i]["id"];
//         var role = data[i]["role"];
//         var amount = data[i]["amount"];
//         var price = data[i]["price"];
//         var province_name = get_province(data[i].district_id).PROVINCE_NAME;
//         var amphur_name = get_amphur(data[i].district_id).AMPHUR_NAME;
//         var district_name = get_district(data[i].district_id).DISTRICT_NAME;

//         html += card_announcement(id, role, amount, price, province_name, amphur_name, district_name);
//       }
//       document.getElementById(target_id).innerHTML = html;
//     });
//   }, update_time);


// }



var show_rating = function (target_id, rating_avg) {
  var output = "";
  var rating_remain = rating_avg % 1;
  var rating_int = rating_avg - rating_remain;

  for (var i = 0; i < rating_int; i++) {
    output += "<span><i class='fa fa-star'></i></span>";
  }

  for (var i = 0; i < (5 - rating_int); i++) {
    if ((i == 0) && (rating_remain >= 0.5))  {
      output += "<span><i class='fa fa-star-half-o'></i></span>";
    } else {
      output += "<span><i class='fa fa-star-o'></i></span>";
    }
  }

  document.getElementById(target_id).innerHTML = output;
}


var getTimeRemaining = function (endtime) {
  var t = Date.parse(endtime) - Date.parse(new Date());
  var seconds = Math.floor( (t/1000) % 60 );
  var minutes = Math.floor( (t/1000/60) % 60 );
  var hours = Math.floor( (t/(1000*60*60)) % 24 );
  var days = Math.floor( t/(1000*60*60*24) );
  return {
    'total': t,
    'days': days,
    'hours': hours,
    'minutes': minutes,
    'seconds': seconds
  };
}

var initializeClock = function (id, endtime) {
  var clock = document.getElementById(id);
  var daysSpan = clock.querySelector('.days');
  var hoursSpan = clock.querySelector('.hours');
  var minutesSpan = clock.querySelector('.minutes');
  var secondsSpan = clock.querySelector('.seconds');

  function updateClock() {
    var t = getTimeRemaining(endtime);

    daysSpan.innerHTML = t.days;
    hoursSpan.innerHTML = ('0' + t.hours).slice(-2);
    minutesSpan.innerHTML = ('0' + t.minutes).slice(-2);
    secondsSpan.innerHTML = ('0' + t.seconds).slice(-2);

    if (t.total <= 0) {
      clearInterval(timeinterval);
      clock.innerHTML = "<p class='center' style='color: red;'>หมดอายุแล้ว</p>";
    }
  }

  updateClock();
  var timeinterval = setInterval(updateClock, 1000);
}
