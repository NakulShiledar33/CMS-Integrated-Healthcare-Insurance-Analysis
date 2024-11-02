import re
from tabulate import tabulate


def get_num_int(value):
    res = re.findall("[0-9,]+", value)
    if res:
        return res[0].replace(",", "")
    else:
        return None


def get_num_decimal(value):
    res = re.findall("[0-9.,]+", value)
    if res:
        return res[0].replace(",", "")
    else:
        return 0


def get_desc(value):
    res = re.findall("[a-zA-Z ]+", value)
    if res:
        return res[0].strip()
    else:
        return None


def get_age_pair(age_str):
    if age_str == '0-14':
        return 0, 14
    elif age_str == '64 and over':
        return 64, 100
    else:
        return age_str, age_str


def print_series(series, header, showindex=False):
    tmp = list()
    for element in series:
        tmp.append([element])
    print(tabulate(tmp, headers=[header], tablefmt="fancy_grid", showindex=showindex))


def print_data_frame(data_frame, headers, showindex=False, pageindex=None, pagesize=None):
    # Do not need pagination
    if pageindex is None or pagesize is None:
        print(tabulate(data_frame, headers=headers, tablefmt="fancy_grid", showindex=showindex))
        return

    start_index = pageindex * pagesize
    end_index = min(start_index + pagesize, len(data_frame))
    print(tabulate(data_frame[start_index:end_index], headers=headers, tablefmt="fancy_grid", showindex=showindex))


def print_single_data(data):
    print(tabulate(data, tablefmt="fancy_grid"))
