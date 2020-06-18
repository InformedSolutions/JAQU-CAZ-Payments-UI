import Litepicker from "litepicker";
import "jquery";
import {
  loadAllPolyfills,
  addPrecedingZero,
  convertUTCToLocal,
} from "../src/ie11Helpers";

/**
 * All times in local timezone unless specified otherwise
 *
 * new Date("2020-6-1") returns date in local timezone
 * new Date("2020-06-01") returns date in UTC
 *
 * IE11 does not support single digit month/day
 *   eg new Date("2020-6-1") - double digit should be used
 * 
 * 86400 - day in seconds
 */

const isIE11 = !!window.MSInputMethodContext && !!document.documentMode;

isIE11 && loadAllPolyfills();

const isStartDateClass = "is-start-date";
const isInRangeClass = "is-in-range";
const isEndDateClass = "is-end-date";
const isDisabledClass = "is-disabled";
const classes = [
  isStartDateClass,
  isInRangeClass,
  isEndDateClass,
  isDisabledClass,
];

/**
 * datesData type definition
 *
 * @typedef {Object} DateData
 * @property {string} value
 * @property {string} name
 * @property {string} hint
 * @property {boolean} disabled
 * @property {boolean} today
 */

/**
 * Data from dates_controller - @dates
 *
 * @type {DateData[]}
 */
const datesData = JSON.parse(
  document.getElementById("dates_data").getAttribute("data")
);

/**
 * Formats the date to YYYY-MM-DD without the preceding zero
 * unless the browser is IE11
 *   eg !IE11 2020-6-1, 2019-11-30
 *   eg IE11 2020-06-01, 2019-11-30
 *
 * @param {Date} date
 *
 * @returns {string} formatted date
 */
const dateToString = (date) => {
  const year = date.getFullYear();
  const month = !isIE11
    ? date.getMonth() + 1
    : addPrecedingZero(date.getMonth() + 1);
  const day = !isIE11 ? date.getDate() : addPrecedingZero(date.getDate());

  return `${year}-${month}-${day}`;
};

const today = new Date().setHours(0, 0, 0, 0);

const startDateMS = today - 6 * 86400 * 1000;
const endDateMS = today + 6 * 86400 * 1000;

/**
 * Dates of paid days in YYYY-MM-DD format without
 * the preceding zero unless the browser is IE11
 *   eg !IE11 2020-6-1, 2019-11-30
 *   eg IE11 2020-06-01, 2019-11-30
 */
const paidDates = datesData
  .filter((date) => date.disabled)
  .map((date) => dateToString(new Date(date.value)));

/**
 * Dates of paid days in milliseconds
 */
const paidDaysMS = paidDates.map((date) => new Date(date).getTime());

/**
 * Date currently selected
 */
let selectedDate = new Date(0);

/**
 * Checks if given date is between
 * the start and end date
 *
 * @param {number} dateInMS - time in milliseconds
 *
 * @returns {boolean}
 */
const isDateInRange = (dateInMS) =>
  startDateMS <= dateInMS && dateInMS <= endDateMS;

/**
 * Highlights the date provided as a parameter
 * along with next 6 days.
 *
 * @param {Date} firstDay - 1st day of selected week
 */
const highlightWeek = (firstDay) => {
  if (!firstDay.getTime()) return;

  for (let i = 0; i < 7; i++) {
    const timestamp = firstDay.getTime() + i * 86400 * 1000;

    const isPaidDate = paidDaysMS.includes(timestamp);
    const isInRange = isDateInRange(timestamp);

    if (i === 0 && !isPaidDate && isInRange) {
      $(`.day-item[data-time=${timestamp}]`).addClass(isStartDateClass);
    } else if (i === 6) {
      $(`.day-item[data-time=${timestamp}]`).addClass(isEndDateClass);
    } else {
      $(`.day-item[data-time=${timestamp}]`).addClass(isInRangeClass);
    }
  }
};

/**
 * Resets all classes used for highlighting
 * days in the calendar
 */
const resetHighlight = () =>
  classes.forEach((className) => $(`.${className}`).removeClass(className));

/**
 * Is called when:
 *   1) clicking the date in the calendar
 *   2) entering a valid day/month/year in the input
 *
 * @param {Date} date - selected date
 */
const onSelectAction = (date) => {
  const stringDate = dateToString(date);

  const isInRange = isDateInRange(date.getTime());

  if (!paidDates.includes(stringDate) && isInRange) {
    selectedDate = date;

    writeDateToInputs(date);
    highlightWeek(date);
    handleEndDayNotice(date);
  }
};

/**
 * Updates value of date inputs
 *
 * @param {Date} date
 */
const writeDateToInputs = (date) => {
  document.getElementById("date-day").value = date.getDate();
  document.getElementById("date-month").value = date.getMonth() + 1;
  document.getElementById("date-year").value = date.getFullYear();
};

/**
 * Called on hovering a day in the calendar
 *
 * @param {Date} date - hovered day
 * @param {string[]} attrs - classes of hovered day element
 */
const onDayHoverAction = (date, attrs) => {
  resetHighlight();

  if (!date || attrs.includes("is-locked")) return;

  highlightWeek(date);
};

const pickerInstance = new Litepicker({
  element: document.getElementById("litepicker"),
  minDate: dateToString(new Date(startDateMS)),
  maxDate: dateToString(new Date(endDateMS)),
  numberOfMonths: 2,
  numberOfColumns: 2,
  lockDays: paidDates,
  showTooltip: false,
  scrollToDate: true,
  autoRefresh: true,
  moveByOneMonth: true,
  onSelect: onSelectAction,
  onShow: () => {
    selectedDate !== new Date(0) && getValuesFromInputs();
  },
  onDayHover: onDayHoverAction,
});

/**
 * Gets the date from inputs with a simple validation.
 *
 * inputDateString will always have date without preceding zero
 * even if value input is with zeros unless the browser is IE11
 *   eg !IE11 2020-6-1, 2019-11-30
 *   eg IE11 2020-06-01, 2019-11-30
 */
const getValuesFromInputs = () => {
  const today = new Date();
  const partials = ["date-day", "date-month", "date-year"].map(
    (id) => document.getElementById(id).value
  );

  // If each input is null
  if (!partials.some(Boolean)) return;

  const dayRaw = partials[0] ? Number(partials[0]) : today.getDate();
  const monthRaw = partials[1] ? Number(partials[1]) : today.getMonth() + 1;
  const year = partials[2] ? Number(partials[2]) : today.getFullYear();

  // IE11 does not accept date containing single digits
  const day = !isIE11 ? dayRaw : addPrecedingZero(dayRaw);
  const month = !isIE11 ? monthRaw : addPrecedingZero(monthRaw);

  const inputDateString = `${year}-${month}-${day}`;
  const inputDate = !isIE11
    ? new Date(inputDateString)
    : convertUTCToLocal(new Date(inputDateString));

  if (inputDate === selectedDate || isNaN(inputDate)) return;

  const isInRange = isDateInRange(inputDate.getTime());
  const isPaidDate = paidDates.includes(inputDateString);

  if (!isInRange || isPaidDate) {
    selectedDate = new Date(0);
    pickerInstance.clearSelection();
    writeDateToInputs(inputDate);
    resetHighlight();
    handleEndDayNotice();
    $(`.day-item[data-time=${inputDate.getTime()}]`).addClass(isDisabledClass);
    return;
  }

  resetHighlight();
  selectedDate = inputDate;
  pickerInstance.setDate(inputDate);
};

/**
 * @param {Date} [date] - selected date
 */
const handleEndDayNotice = (date) => {
  const el = document.getElementById("week-last-day-notice");

  if (!date) {
    el.innerText = "";
    return;
  }

  const endDay = new Date(date.getTime() + 6 * 86400 * 1000);
  const day = addPrecedingZero(endDay.getDate());
  const month = addPrecedingZero(endDay.getMonth() + 1);
  const year = endDay.getFullYear();

  el.innerText = `Your weekly charge will end on ${day} ${month} ${year}`;
};

const initializeListeners = () => {
  ["date-day", "date-month", "date-year"].forEach((id) => {
    document
      .getElementById(id)
      .addEventListener("click", () => pickerInstance.show());
    document
      .getElementById(id)
      .addEventListener("change", () => getValuesFromInputs());
  });
};

initializeListeners();
