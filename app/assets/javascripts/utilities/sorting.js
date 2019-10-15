document.addEventListener('turbolinks:load', function() {
  var control = document.querySelector('.tab-sorted')
  if (control) {
    var thead = control.getElementsByTagName('thead')[0]
    var th_control = thead.querySelector('.sort-by-title')
     console.log(th_control)
    if (th_control) {
        th_control.addEventListener('click', sortRowsByTitle())
      }
    }
});

function sortRowsByTitle() {
  var table = document.querySelector('.tab-sorted')
  console.log(table)
  var body_prev = table.getElementsByTagName('tbody')[0]
  console.log(body_prev)
  var rows = body_prev.querySelectorAll('tr')
  console.log(rows)

  var sortedRows = []
  for (var i = 0; i < rows.length; i++) {
      sortedRows.push(rows[i])
  }
  console.log(body_prev)

  var head =  table.getElementsByTagName('thead')[0]
  var head_length = head.rows[0].children.length

  if (head.querySelector('.octicon-arrow-up').classList.contains('hide')) {
    sortedRows.sort(compareRowsAsc)
    head.querySelector('.octicon-arrow-up').classList.remove('hide')
    head.querySelector('.octicon-arrow-down').classList.add('hide')
    console.log('1--->> sortedRows.sort(compareRowsAsc)')
   } else {
    sortedRows.sort(compareRowsDesc)
    head.querySelector('.octicon-arrow-up').classList.add('hide')
    head.querySelector('.octicon-arrow-down').classList.remove('hide')
    console.log('2--->> sortedRows.sort(compareRowsDesc)')
  }

  console.log(body_prev)

  // var  sorted_body = document.createElement('tbody')

  var sorted_body = document.createElement('tbody')
  sorted_body.classList.add('sort-body')
  for (var m = 0; m < sortedRows.length; m++) {
    sorted_body.appendChild(sortedRows[m])
  }
  console.log(sorted_body)
  console.log(body_prev)
  console.log(body_prev.parentNode)

  body_prev.parentNode.replaceChild(sorted_body, body_prev)
}

function compareRowsAsc(row1, row2) {
  var testTitle1 = row1.querySelector('td').textContent
  var testTitle2 = row2.querySelector('td').textContent

  if (testTitle1 < testTitle2) { return -1 }
  if (testTitle1 > testTitle2) { return 1 }
  return 0
}

function compareRowsDesc(row1, row2) {
  var testTitle1 = row1.querySelector('td').textContent
  var testTitle2 = row2.querySelector('td').textContent

  if (testTitle1 < testTitle2) { return 1 }
  if (testTitle1 > testTitle2) { return -1 }
  return 0
}
