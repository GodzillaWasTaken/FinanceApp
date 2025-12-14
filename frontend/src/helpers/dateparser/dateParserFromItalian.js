/**
 * parse data from Italian format (DD/MM/YYYY) to us format in various ways
 */

/**
 * Extract YYYY-MM from an Italian date (DD/MM/YYYY)
 */
function extractMonthYear(dateIt) {
  const [day, month, year] = dateIt.split('/')
  return `${year}-${month.padStart(2, '0')}`
}

export { extractMonthYear }