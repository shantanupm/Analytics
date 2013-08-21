function isDate(txtDate) {
    var objDate,  // date object initialized from the txtDate string
        mSeconds, // txtDate in milliseconds
        day,      // day
        month,    // month
        year;     // year
    // date length should be 10 characters (no more no less)
    if (txtDate.length !== 10) {
        return false;
    }
    // third and sixth character should be '/'
    if (txtDate.substring(2, 3) !== '/' || txtDate.substring(5, 6) !== '/') {
        return false;
    }
    // extract month, day and year from the txtDate (expected format is mm/dd/yyyy)
    // subtraction will cast variables to integer implicitly (needed
    // for !== comparing)
    month = txtDate.substring(0, 2) - 1; // because months in JS start from 0
    day = txtDate.substring(3, 5) - 0;
    year = txtDate.substring(6, 10) - 0;
    // test year range
    if (year < 1000 || year > 3000) {
        return false;
    }
    // convert txtDate to milliseconds
    mSeconds = (new Date(year, month, day)).getTime();
    // initialize Date() object from calculated milliseconds
    objDate = new Date();
    objDate.setTime(mSeconds);
    // compare input date and parts from Date() object
    // if difference exists then date isn't valid
    if (objDate.getFullYear() !== year ||
        objDate.getMonth() !== month ||
        objDate.getDate() !== day) {
        return false;
    }
    // otherwise return true
    return true;
}


//compare dates and return number of days between
function cmpDate(dat1, dat2) {
    var day = 1000 * 60 * 60 * 24, // milliseconds in one day
        mSec1, mSec2;              // milliseconds for dat1 and dat2
    // valudate dates
    if (!isDate(dat1) || !isDate(dat2)) {
        alert("cmpDate: Input parameters are not dates!");
        return 0;
    }
    // prepare milliseconds for dat1 and dat2
    mSec1 = (new Date(dat1.substring(6, 10), dat1.substring(0, 2) - 1, dat1.substring(3, 5))).getTime();
    mSec2 = (new Date(dat2.substring(6, 10), dat2.substring(0, 2) - 1, dat2.substring(3, 5))).getTime();
    // return number of days (positive or negative)
    return Math.ceil((mSec2 - mSec1) / day);
}

//compare with current Date and return number of days between
function cmpCurrentDate(dat1,datInMsec) {
    var day = 1000 * 60 * 60 * 24, // milliseconds in one day
        mSec1, mSec2;              // milliseconds for dat1 and dat2
    // valudate dates
    if (!isDate(dat1)) {
       // alert("cmpDate: Input parameters are not dates!");
        return 0;
    }
   
    // prepare milliseconds for dat1 and dat2
    mSec1 = (new Date(dat1.substring(6, 10), dat1.substring(0, 2) - 1, dat1.substring(3, 5))).getTime();
    mSec2 = datInMsec;
    // return number of days (positive or negative)
    return Math.ceil((mSec2 - mSec1) / day);
}