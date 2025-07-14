def create_re_chunk(prefix, data, postfix):
    return {'prefix': prefix, 'data': data, 'postfix': postfix}


def get_left_shift_ind(ind: int, left_shift: int):
    new_index = ind - left_shift
    return new_index if new_index >= 0 else 0
