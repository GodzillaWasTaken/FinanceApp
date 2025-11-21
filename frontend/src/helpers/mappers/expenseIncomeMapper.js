/**
 * Maps raw expense and income data to chart-friendly format
 * 
 * used to parse an array of expense/income objects into the series gouped by category and month
 * 
 * @paramm {Arrray} serie - array of object containing date, amount and category
 * 
 * @return {Object} - mapped data ready to be used in charts
 * 
 * Example input:
 * [
 *    { date: "10/01/2024", amount: 20, category: "Car" },
 *    { date: "12/01/2024", amount: 60, category: "Food" },
 *    { date: "05/02/2024", amount: 40, category: "Car" },
 *    { date: "10/02/2024", amount: 100, category: "Shopping" },
 *    { date: "15/02/2024", amount: 20, category: "Food" }
 * ]
 *
 * 
 * Example output:
 * {
 *  months: ["2024-01", "2024-02"],
 *  categoryMap: {
 *    Car: {
 *      "2024-01": 20,
 *     "2024-02": 40
 *    },
 *    Food: {
 *      "2024-01": 60,
 *      "2024-02": 20
 *    },
 *    Shopping: {
 *      "2024-02": 100
 *    }
 *  }
 *}
 *       
 */

import { extractMonthYear } from '@/helpers/dateparser/dateParserFromItalian.js'



/**
 * Maps raw expense/income data by category and month
 * 
 * @param {Array} serie - array of objects: { date, amount, categoria }
 * @returns {Object} { months: Array<string>, categoryMap: Object }
 */
export function mapSerie(serie = []) {
  const monthSet = new Set()
  const categoryMap = {}

  serie.forEach(item => {
    const month = extractMonthYear(item.date)
    const cat = item.category

    monthSet.add(month)

    if (!categoryMap[cat]) categoryMap[cat] = {}
    if (!categoryMap[cat][month]) categoryMap[cat][month] = 0

    categoryMap[cat][month] += item.amount
  })

  const months = Array.from(monthSet).sort()

  return {
    months,
    categoryMap
  }
}
