# coding: utf-8
#
# This plugin identifies faces under default configuration settings and sends the identification results to a websocket.
#
import base64
import io
from tornado import websocket, web
from facenapi.core.http.base_handler import BaseHandler
from facenapi.server.base_video_handler import BaseVideoHandler

def activate(app, ctx, options):
    app.demo_websockets = {}

    class FrameHandler(BaseVideoHandler):
        async def process_frame(self, *args, image, faces, timestamp, detector_info, **kwargs):
            await self.ctx.extractor.enrich(faces, facen=True)

            for face in faces:
                results = await self.ctx.faces.identify(self.user, 'default', face, limit=10, threshold=0.75)
                thumb_rect = image.shape.intersect(face.bbox)
                thumb_img = image.img.crop((thumb_rect.left, thumb_rect.top, thumb_rect.right, thumb_rect.bottom))
                thumb_contents = io.BytesIO()
                thumb_img.save(thumb_contents, format='JPEG', quality=80)
                thumb_contents.seek(0)
                event_html = []
                event_html.append('<tr><td><img src="data:image/jpeg;base64,%s" /></td>' % base64.b64encode(thumb_contents.getvalue()).decode())
                event_html.append('<td>')
                for result in results:
                    event_html.append('<img src="%s" />' % (result.face['thumbnail']))
                event_html.append('</td></tr>')
                for socket in self.application.demo_websockets.values():
                    try:
                        socket.write_message('\n'.join(event_html).encode('utf-8'))
                    except:
                        pass

    class WebSocketHandler(websocket.WebSocketHandler, BaseHandler):
        def check_origin(self, origin):
            return True

        def set_default_headers(self):
            pass

        def open(self):
            self.application.demo_websockets[id(self)] = self

        def on_close(self):
            del self.application.demo_websockets[id(self)]

        def prepare(self):
            self.ctx = self.application.ctx

    class PageHandler(web.RequestHandler):
        def get(self):
            self.write('''
<html>
<style> img { max-width: 100px; max-height: 100px; } </style>
<body>
<table id='events' border='1'><tr id='header'><td>Received</td><td>Found</td></tr>
</table>
<script>
var ws = new WebSocket('ws://'+window.location.host+'/demo/socket');
var header = document.getElementById('header');
ws.onmessage = function (msg) {
    var event = document.createElement('tr');
    event.innerHTML = msg.data;
    header.parentNode.insertBefore(event, header.nextSibling);
}
</script>
</body>
</html>
''')

    app.add_handlers('.*', [
        ('/demo/frame', FrameHandler),
        ('/demo/socket', WebSocketHandler),
        ('/demo/', PageHandler),
    ])

