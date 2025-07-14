from os import stat

BYTES_IN_MB = 1024 * 1024


def get_file_size(path):
    return round(stat(path).st_size / BYTES_IN_MB, 3)
