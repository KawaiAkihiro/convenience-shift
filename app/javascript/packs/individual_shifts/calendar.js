import { Calendar, whenTransitionDone } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new Calendar(calendarEl, {
        plugins: [ dayGridPlugin, interactionPlugin ],
        events: '/individual_shifts.json',
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        //scrollTime: '07:00:00',
        dateClick: function(info){
            const year  = info.date.getFullYear();
            const month = (info.date.getMonth() + 1);
            const day   = info.date.getDate();

            
            $.ajax({
                type: 'GET',
                url:  '/individual_shifts/new',
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
        },
        eventClick: function(info){
            var shift_id = info.event.id
            var str = '<a class="btn btn-primary" data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="individual_shifts/' + shift_id + '">削除する</a>'
            
            $('.modal-body2').html(str)
            $('#modal2').fadeIn();
        }
    });

    calendar.render();
});