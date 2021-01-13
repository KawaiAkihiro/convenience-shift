import { Calendar, whenTransitionDone } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import weekGridPlugin from '@fullcalendar/timegrid'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new Calendar(calendarEl, {
        plugins: [ weekGridPlugin, interactionPlugin ],
        events: '/comfirmed_shifts.json',
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        scrollTime: '07:00:00',
        header: {
            left: '',
            center: 'title',
            right: 'today prev,next' 
        }
    });

    calendar.render();
});
