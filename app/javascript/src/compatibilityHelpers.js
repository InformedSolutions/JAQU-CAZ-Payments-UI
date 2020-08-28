// IE11 polyfill for Object.entries()
function loadObjectEntriesPolyfill() {
  if (!Object.entries)
    Object.entries = function (obj) {
      var ownProps = Object.keys(obj),
        i = ownProps.length,
        resArray = new Array(i); // preallocate the Array
      while (i--) resArray[i] = [ownProps[i], obj[ownProps[i]]];

      return resArray;
    };
}

// IE11 polyfill for String.includes() and Array.includes()
function loadIncludesPolyfill() {
  if (!String.prototype.includes) {
    Object.defineProperty(String.prototype, "includes", {
      enumerable: false,
      writable: true,
      value: function (search, start) {
        "use strict";
        if (typeof start !== "number") {
          start = 0;
        }

        if (start + search.length > this.length) {
          return false;
        } else {
          return this.indexOf(search, start) !== -1;
        }
      },
    });
  }

  if (!Array.prototype.includes) {
    Object.defineProperty(Array.prototype, "includes", {
      enumerable: false,
      writable: true,
      value: function (searchElement /*, fromIndex*/) {
        "use strict";
        var O = Object(this);
        var len = parseInt(O.length) || 0;
        if (len === 0) {
          return false;
        }
        var n = parseInt(arguments[1]) || 0;
        var k;
        if (n >= 0) {
          k = n;
        } else {
          k = len + n;
          if (k < 0) {
            k = 0;
          }
        }
        var currentElement;
        while (k < len) {
          currentElement = O[k];
          if (
            searchElement === currentElement ||
            (searchElement !== searchElement &&
              currentElement !== currentElement)
          ) {
            // NaN !== NaN
            return true;
          }
          k++;
        }
        return false;
      },
    });
  }
}

export function loadAllPolyfills() {
  loadObjectEntriesPolyfill();
  loadIncludesPolyfill();
}

/**
 * Converts 1-digit number to 2-digit number
 *
 * eg addPrecedingZero("5") === "05"
 *    addPrecedingZero("15") === "15"
 *
 * @param {string | number} value
 *
 * @returns {string}
 */
export const addPrecedingZero = (value) => ("0" + value).slice(-2);

/**
 *
 * @param {Date} date - date in UTC time
 *
 * @return {Date} = date in local timezone
 */
export const convertUTCToLocal = (date) => new Date(date.setHours(0, 0, 0, 0));

const isSafari =
  /constructor/i.test(window.HTMLElement) ||
  (function (p) {
    return p.toString() === "[object SafariRemoteNotification]";
  })(
    !window["safari"] ||
      (typeof safari !== "undefined" && safari.pushNotification)
  );

export const isIE11 = !!window.MSInputMethodContext && !!document.documentMode;

/**
 * Always add preceding zero if browser is unsupported
 */
export const addZero = isIE11 || isSafari;
