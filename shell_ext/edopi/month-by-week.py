#!/usr/local/bin/python3.12
"""
(CC) Edopi Corp. To Python with love.
Part of a progressive migration away from Bash automation.

Script month-by-week.py
is expected to produce empty template for monthly hours report listed by weeks.

Example for the month Septemper 2023
--------

## September
-  1- 1:
-  4- 8:
- 11-15:
- 18-22:
- 25-29:

"""

import sys
from datetime import date, timedelta
from calendar import month_name
from os import getenv


def week_ranges_list(year, month):
    """Return the ranges (first,last) in day number of the weeks in the provided month.

    >>> week_ranges_list(2023, 9)
    [(1, 1), (4, 8), (11, 15), (18, 22), (25, 29)]

    >>> week_ranges_list(2023, 1)
    [(2, 6), (9, 13), (16, 20), (23, 27), (30, 31)]

    >>> week_ranges_list(1970, 1)
    [(1, 2), (5, 9), (12, 16), (19, 23), (26, 30)]
    """

    week_ranges = []
    oneday = timedelta(days=1)
    monday, friday, saturday = 0, 4, 5
    week_start = date(year, month, 1)
    while not (monday <= week_start.weekday() <= friday):
        week_start += oneday
    currday = week_start
    while month == week_start.month:
        nextday = currday + oneday
        if nextday.weekday() == saturday or nextday.month > month:
            week_ranges.append((week_start.day, currday.day))
            week_start = currday + 3 * oneday

        currday = nextday
        # print(currday, week_ranges)

    return week_ranges


def print_month(year, month):
    curr_month_name = month_name[date(year, month, 1).month]
    print(f"## {curr_month_name}")
    for start, end in week_ranges_list(year, month):
        print(f"- {start:>2}-{end:>2}:")


today = date.today()
YEAR, MONTH = today.year, today.month

args = sys.argv[1:]
if len(args) == 1 and '-' in args[0]:
    # 2026-02
    YEAR, MONTH = args[0].split('-')
elif len(args) == 2:
    # 2026 01
    YEAR, MONTH = args
elif len(args) == 1:
    # 1 | 01 - 12: just month, current year
    MONTH = args[0]
else:
    # fallback to env vars
    YEAR = getenv("YEAR", YEAR)
    MONTH = getenv("MONTH", MONTH)

print_month(int(YEAR), int(MONTH))
