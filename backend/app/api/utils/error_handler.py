from functools import wraps


def error_handler(function):
    @wraps(function)
    def wrapper(*args, **kwargs):
        try:
            return function(*args, **kwargs)
        except Exception:
            import traceback
            with open('errors.log', 'a+') as file:
                traceback.print_exc(file=file)
            traceback.print_exc()
    return wrapper
