# coding: utf-8
#
# This plugin identifies faces from fkvideo_detector (configured by default) and saves the identification results to a static HTML file.
#
import base64
import io
from facenapi.server.base_video_handler import BaseVideoHandler

def activate(app, ctx, options):
    output = open('/home/stiletto/public_html/found.html', 'w')
    print('<style> img { max-width: 100px; max-height: 100px; } </style><table><tr><td>Needle</td><td>Found</td></tr>', file=output)
    output.flush()

    class DemoHandler(BaseVideoHandler):
        async def process_frame(self, *args, image, faces, timestamp, detector_info, **kwargs):
            with self.timeit('nnapi'):
                await self.ctx.extractor.enrich(faces, facen=True)

            for face in faces:
                results = await self.ctx.faces.identify(self.user, 'default', face, limit=10, threshold=0.75)
                thumb_rect = image.shape.intersect(face.bbox)
                thumb_img = image.img.crop((thumb_rect.left, thumb_rect.top, thumb_rect.right, thumb_rect.bottom))
                thumb_contents = io.BytesIO()
                thumb_img.save(thumb_contents, format='JPEG', quality=80)
                thumb_contents.seek(0)

                print('<tr><td><img src="data:image/jpeg;base64,%s" /></td>' % base64.b64encode(
                    thumb_contents.getvalue()).decode(), file=output)
                print('<td>', file=output)
                for result in results:
                    print('<img src="%s" />' % (result.face['thumbnail']), file=output)
                print('</td></tr>', file=output)
                output.flush()

    app.add_handlers('.*', [
        ('/static-demo/frame', DemoHandler),
    ])
