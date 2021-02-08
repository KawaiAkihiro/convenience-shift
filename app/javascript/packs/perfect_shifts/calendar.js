import { Calendar, whenTransitionDone } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import weekGridPlugin from '@fullcalendar/timegrid'
import { event } from 'jquery';
//import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new Calendar(calendarEl, {
        plugins: [ weekGridPlugin, interactionPlugin ],
        events: '/perfect_shifts.json',
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        scrollTime: '07:00:00',
        expandRows: true,
        stickyHeaderDates: true,
        headerToolbar: {
            left: 'title',
            center: '',
            right: 'today prev,next' 
        },
        firstDay: 1,
        buttonText: {
            today: '今日'
        }, 
        allDayText: '営業 催事',
        height: "auto",
        dateClick: function(info){
            const year  = info.date.getFullYear();
            const month = (info.date.getMonth() + 1);
            const day   = info.date.getDate();
            const hour  = (info.date.getHours());

            var ja_hour = 0

            if(hour < 9){
                ja_hour = hour + 15;
            }else{
                ja_hour = hour - 9;
            }

            var str_hour = ""

            if(ja_hour < 10){
                str_hour = "0" + ja_hour
            }else
                str_hour = ja_hour

            if(hour == 9){
                $.ajax({
                    type: 'GET',
                    url:  '/perfect_shifts/new_plan',
                }).done(function (res) {
                    //イベント登録用のhtmlを作成
                    $('.modal-body').html(res);
                    
                    $('#individual_shift_start_1i').val(year);
                    $('#individual_shift_start_2i').val(month);
                    $('#individual_shift_start_3i').val(day);
                
                    $('#modal').fadeIn();
                    // 成功処理
                }).fail(function (result) {
                    // 失敗処理
                    alert("failed");
                });
            }
        },        
        eventClassNames: function(arg){
            if(arg.event.allDay){
                return [ 'horizon' ]
            }else{
                return [ 'vertical' ]
            }
        },
        eventClick: function(info){
            var id = info.event.id

            if(info.el.style.backgroundColor == "yellow"){
                $.ajax({
                    type: "GET",
                    url:  "/perfect_shifts/fill",
                    data: { shift_id : id },
                    datatype: "html",
                }).done(function(res){
                
                    $('.modal-body').html(res)
                    $('#modal').fadeIn();
                }).fail(function (result) {
                    // 失敗処理
                    alert("failed");
                });
            }else if(info.el.style.backgroundColor == "white"){
                $.ajax({
                    type: "GET",
                    url:  "/perfect_shifts/change",
                    data: { shift_id : id },
                    datatype: "html",
                }).done(function(res){
                
                    $('.modal-body').html(res)
                    $('#modal').fadeIn();
                }).fail(function (result) {
                    // 失敗処理
                    alert("failed");
                });
            }
        }
    });
    calendar.render();

    $('button').click(function(){
        calendar.refetchEvents();
    });
});

$(function(){
    $('button.plan').click(function(){
        $.ajax({
            type: 'GET',
            url:  '/perfect_shifts/new_plan',
        }).done(function (res) {
            //イベント登録用のhtmlを作成
            $('.modal-body').html(res);
        
            $('#modal').fadeIn();
            // 成功処理
        }).fail(function (result) {
            // 失敗処理
            alert("failed");
        });
    });
});