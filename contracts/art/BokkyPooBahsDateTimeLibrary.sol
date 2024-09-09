// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

// ----------------------------------------------------------------------------
// BokkyPooBah's DateTime Library v1.01
//
// A gas-efficient Solidity date and time library
//
// https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
//
// Tested date range 1970/01/01 to 2345/12/31
//
// Conventions:
// Unit      | Range         | Notes
// :-------- |:-------------:|:-----
// timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
// year      | 1970 ... 2345 |
// month     | 1 ... 12      |
// day       | 1 ... 31      |
// hour      | 0 ... 23      |
// minute    | 0 ... 59      |
// second    | 0 ... 59      |
// dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
//
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018-2019. The MIT Licence.
// ----------------------------------------------------------------------------

library BokkyPooBahsDateTimeLibrary {

    uint64 constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint64 constant SECONDS_PER_HOUR = 60 * 60;
    uint64 constant SECONDS_PER_MINUTE = 60;
    int64 constant OFFSET19700101 = 2440588;

    uint64 constant DOW_MON = 1;
    uint64 constant DOW_TUE = 2;
    uint64 constant DOW_WED = 3;
    uint64 constant DOW_THU = 4;
    uint64 constant DOW_FRI = 5;
    uint64 constant DOW_SAT = 6;
    uint64 constant DOW_SUN = 7;

    // ------------------------------------------------------------------------
    // Calculate the number of days from 1970/01/01 to year/month/day using
    // the date conversion algorithm from
    //   https://aa.usno.navy.mil/faq/JD_formula.html
    // and subtracting the offset 2440588 so that 1970/01/01 is day 0
    //
    // days = day
    //      - 32075
    //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
    //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
    //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
    //      - offset
    // ------------------------------------------------------------------------
    function _daysFromDate(uint64 year, uint64 month, uint64 day) internal pure returns (uint64 _days) {
        require(year >= 1970);
        int64 _year = int64(year);
        int64 _month = int64(month);
        int64 _day = int64(day);

        int64 __days = _day
          - 32075
          + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
          + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
          - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
          - OFFSET19700101;

        _days = uint64(__days);
    }

    // ------------------------------------------------------------------------
    // Calculate year/month/day from the number of days since 1970/01/01 using
    // the date conversion algorithm from
    //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
    // and adding the offset 2440588 so that 1970/01/01 is day 0
    //
    // int64 L = days + 68569 + offset
    // int64 N = 4 * L / 146097
    // L = L - (146097 * N + 3) / 4
    // year = 4000 * (L + 1) / 1461001
    // L = L - 1461 * year / 4 + 31
    // month = 80 * L / 2447
    // dd = L - 2447 * month / 80
    // L = month / 11
    // month = month + 2 - 12 * L
    // year = 100 * (N - 49) + year + L
    // ------------------------------------------------------------------------
    function _daysToDate(uint64 _days) internal pure returns (uint64 year, uint64 month, uint64 day) {
        int64 __days = int64(_days);

        int64 L = __days + 68569 + OFFSET19700101;
        int64 N = 4 * L / 146097;
        L = L - (146097 * N + 3) / 4;
        int64 _year = 4000 * (L + 1) / 1461001;
        L = L - 1461 * _year / 4 + 31;
        int64 _month = 80 * L / 2447;
        int64 _day = L - 2447 * _month / 80;
        L = _month / 11;
        _month = _month + 2 - 12 * L;
        _year = 100 * (N - 49) + _year + L;

        year = uint64(_year);
        month = uint64(_month);
        day = uint64(_day);
    }

    function timestampFromDate(uint64 year, uint64 month, uint64 day) internal pure returns (uint64 timestamp) {
        timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
    }
    function timestampFromDateTime(uint64 year, uint64 month, uint64 day, uint64 hour, uint64 minute, uint64 second) internal pure returns (uint64 timestamp) {
        timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
    }
    function timestampToDate(uint64 timestamp) internal pure returns (uint64 year, uint64 month, uint64 day) {
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function timestampToDateTime(uint64 timestamp) internal pure returns (uint64 year, uint64 month, uint64 day, uint64 hour, uint64 minute, uint64 second) {
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        uint64 secs = timestamp % SECONDS_PER_DAY;
        hour = secs / SECONDS_PER_HOUR;
        secs = secs % SECONDS_PER_HOUR;
        minute = secs / SECONDS_PER_MINUTE;
        second = secs % SECONDS_PER_MINUTE;
    }

    function isValidDate(uint64 year, uint64 month, uint64 day) internal pure returns (bool valid) {
        if (year >= 1970 && month > 0 && month <= 12) {
            uint64 daysInMonth = _getDaysInMonth(year, month);
            if (day > 0 && day <= daysInMonth) {
                valid = true;
            }
        }
    }
    function isValidDateTime(uint64 year, uint64 month, uint64 day, uint64 hour, uint64 minute, uint64 second) internal pure returns (bool valid) {
        if (isValidDate(year, month, day)) {
            if (hour < 24 && minute < 60 && second < 60) {
                valid = true;
            }
        }
    }
    function isLeapYear(uint64 timestamp) internal pure returns (bool leapYear) {
        (uint64 year,,) = _daysToDate(timestamp / SECONDS_PER_DAY);
        leapYear = _isLeapYear(year);
    }
    function _isLeapYear(uint64 year) internal pure returns (bool leapYear) {
        leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
    }
    function isWeekDay(uint64 timestamp) internal pure returns (bool weekDay) {
        weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
    }
    function isWeekEnd(uint64 timestamp) internal pure returns (bool weekEnd) {
        weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
    }
    function getDaysInMonth(uint64 timestamp) internal pure returns (uint64 daysInMonth) {
        (uint64 year, uint64 month,) = _daysToDate(timestamp / SECONDS_PER_DAY);
        daysInMonth = _getDaysInMonth(year, month);
    }
    function _getDaysInMonth(uint64 year, uint64 month) internal pure returns (uint64 daysInMonth) {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
            daysInMonth = 31;
        } else if (month != 2) {
            daysInMonth = 30;
        } else {
            daysInMonth = _isLeapYear(year) ? 29 : 28;
        }
    }
    // 1 = Monday, 7 = Sunday
    function getDayOfWeek(uint64 timestamp) internal pure returns (uint64 dayOfWeek) {
        uint64 _days = timestamp / SECONDS_PER_DAY;
        dayOfWeek = (_days + 3) % 7 + 1;
    }

    function getYear(uint64 timestamp) internal pure returns (uint64 year) {
        (year,,) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getMonth(uint64 timestamp) internal pure returns (uint64 month) {
        (,month,) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getDay(uint64 timestamp) internal pure returns (uint64 day) {
        (,,day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getHour(uint64 timestamp) internal pure returns (uint64 hour) {
        uint64 secs = timestamp % SECONDS_PER_DAY;
        hour = secs / SECONDS_PER_HOUR;
    }
    function getMinute(uint64 timestamp) internal pure returns (uint64 minute) {
        uint64 secs = timestamp % SECONDS_PER_HOUR;
        minute = secs / SECONDS_PER_MINUTE;
    }
    function getSecond(uint64 timestamp) internal pure returns (uint64 second) {
        second = timestamp % SECONDS_PER_MINUTE;
    }

    function addYears(uint64 timestamp, uint64 _years) internal pure returns (uint64 newTimestamp) {
        (uint64 year, uint64 month, uint64 day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        year += _years;
        uint64 daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp >= timestamp);
    }
    function addMonths(uint64 timestamp, uint64 _months) internal pure returns (uint64 newTimestamp) {
        (uint64 year, uint64 month, uint64 day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        month += _months;
        year += (month - 1) / 12;
        month = (month - 1) % 12 + 1;
        uint64 daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp >= timestamp);
    }
    function addDays(uint64 timestamp, uint64 _days) internal pure returns (uint64 newTimestamp) {
        newTimestamp = timestamp + _days * SECONDS_PER_DAY;
        require(newTimestamp >= timestamp);
    }
    function addHours(uint64 timestamp, uint64 _hours) internal pure returns (uint64 newTimestamp) {
        newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
        require(newTimestamp >= timestamp);
    }
    function addMinutes(uint64 timestamp, uint64 _minutes) internal pure returns (uint64 newTimestamp) {
        newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
        require(newTimestamp >= timestamp);
    }
    function addSeconds(uint64 timestamp, uint64 _seconds) internal pure returns (uint64 newTimestamp) {
        newTimestamp = timestamp + _seconds;
        require(newTimestamp >= timestamp);
    }

    function subYears(uint64 timestamp, uint64 _years) internal pure returns (uint64 newTimestamp) {
        (uint64 year, uint64 month, uint64 day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        year -= _years;
        uint64 daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp <= timestamp);
    }
    function subMonths(uint64 timestamp, uint64 _months) internal pure returns (uint64 newTimestamp) {
        (uint64 year, uint64 month, uint64 day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        uint64 yearMonth = year * 12 + (month - 1) - _months;
        year = yearMonth / 12;
        month = yearMonth % 12 + 1;
        uint64 daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp <= timestamp);
    }
    function subDays(uint64 timestamp, uint64 _days) internal pure returns (uint64 newTimestamp) {
        newTimestamp = timestamp - _days * SECONDS_PER_DAY;
        require(newTimestamp <= timestamp);
    }
    function subHours(uint64 timestamp, uint64 _hours) internal pure returns (uint64 newTimestamp) {
        newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
        require(newTimestamp <= timestamp);
    }
    function subMinutes(uint64 timestamp, uint64 _minutes) internal pure returns (uint64 newTimestamp) {
        newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
        require(newTimestamp <= timestamp);
    }
    function subSeconds(uint64 timestamp, uint64 _seconds) internal pure returns (uint64 newTimestamp) {
        newTimestamp = timestamp - _seconds;
        require(newTimestamp <= timestamp);
    }

    function diffYears(uint64 fromTimestamp, uint64 toTimestamp) internal pure returns (uint64 _years) {
        require(fromTimestamp <= toTimestamp);
        (uint64 fromYear,,) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
        (uint64 toYear,,) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
        _years = toYear - fromYear;
    }
    function diffMonths(uint64 fromTimestamp, uint64 toTimestamp) internal pure returns (uint64 _months) {
        require(fromTimestamp <= toTimestamp);
        (uint64 fromYear, uint64 fromMonth,) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
        (uint64 toYear, uint64 toMonth,) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
        _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
    }
    function diffDays(uint64 fromTimestamp, uint64 toTimestamp) internal pure returns (uint64 _days) {
        require(fromTimestamp <= toTimestamp);
        _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
    }
    function diffHours(uint64 fromTimestamp, uint64 toTimestamp) internal pure returns (uint64 _hours) {
        require(fromTimestamp <= toTimestamp);
        _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
    }
    function diffMinutes(uint64 fromTimestamp, uint64 toTimestamp) internal pure returns (uint64 _minutes) {
        require(fromTimestamp <= toTimestamp);
        _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
    }
    function diffSeconds(uint64 fromTimestamp, uint64 toTimestamp) internal pure returns (uint64 _seconds) {
        require(fromTimestamp <= toTimestamp);
        _seconds = toTimestamp - fromTimestamp;
    }
}
