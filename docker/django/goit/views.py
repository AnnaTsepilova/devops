from django.db import connections
from django.db.utils import OperationalError

from django.shortcuts import render

def home(request):
    db_conn = connections['default']
    try:
        c = db_conn.cursor()
    except OperationalError:
        connected = False
    else:
        connected = True

    db_version = ''
    with db_conn.cursor() as cursor:
        cursor.execute("SELECT version();")
        row = cursor.fetchall()
        db_version = row[0][0]

    context = {
        'db_version': db_version,
        'connected': connected,
    }
    return render(request, 'index.html', context)
