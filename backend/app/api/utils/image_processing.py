from tempfile import TemporaryDirectory
from zipfile import ZipFile
from os import path
from glob import glob
from uuid import uuid4
from base64 import b64encode
import sys

from config import DOC_MEDIA_PATH


def unpack_doc_media(doc_path, out_path):
    with ZipFile(doc_path) as archive:
        members = [member for member in archive.namelist() if member.startswith('word/media')]
        archive.extractall(out_path, members)


if sys.platform.startswith('linux'):
    import subprocess

    def convert_emf_to_png(dir_path):
        for file in glob(path.join(dir_path, '*.emf')):
            new_file = path.join(dir_path, f'{str(uuid4().hex)}.png')
            subprocess.run(['inkscape', '-o', new_file, file])
else:
    from PIL import Image

    def convert_emf_to_png(dir_path):
        for file in glob(path.join(dir_path, '*.emf')):
            new_file = path.join(dir_path, f'{str(uuid4().hex)}.png')
            Image.open(file).save(new_file)


def prepare_img(img_path, img_type):
    with open(img_path, "rb") as image_file:
        return {'src': f'data:image/{img_type};base64,{b64encode(image_file.read()).decode("utf-8")}'}


def make_img_list(dir_path):
    images = []
    for png_img in glob(path.join(dir_path, '*.jpg')):
        images.append(prepare_img(png_img, "jpg"))
    for jpg_img in glob(path.join(dir_path, '*.png')):
        images.append(prepare_img(jpg_img, "png"))
    return images


def get_img_list(doc_path):
    with TemporaryDirectory() as tmpdir:
        unpack_doc_media(doc_path, tmpdir)
        media_path = path.join(tmpdir, DOC_MEDIA_PATH)
        convert_emf_to_png(media_path)
        images = make_img_list(media_path)
        return images
