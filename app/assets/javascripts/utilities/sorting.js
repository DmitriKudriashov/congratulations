document.addEventListener('turbolinks:load', function() {
  //  https://caniuse.com
  var control = document.querySelector('.sort-by-title')
  // console.log(control)
  if (control) {
    control.addEventListener('click', sortRowsByTitle)
  }
});

function sortRowsByTitle() {
    // var table = document.getElementsByName('tab-sorted')
    // console.log(table)
    var body =  document.querySelector('.sort-body')  //  table[0].getElementsByTagName('tbody')
    console.log(body)
    // console.log(body.children)
    // NodeList
    // https://developer.mozilla.org/ru/docs/Web/API/NodeList

    var rows = body.querySelectorAll('tr') // [0].children
    console.log(rows)

    var sortedRows = []
    // Select all rows body
    for (var i = 0; i < rows.length; i++) {
        sortedRows.push(rows[i])
    }

    if (this.querySelector('.octicon-arrow-up').classList.contains('hide')) {
        sortedRows.sort(compareRowsAsc)
        this.querySelector('.octicon-arrow-up').classList.remove('hide')
        this.querySelector('.octicon-arrow-down').classList.add('hide')
    } else {
        sortedRows.sort(compareRowsDesc)
        this.querySelector('.octicon-arrow-up').classList.add('hide')
        this.querySelector('.octicon-arrow-down').classList.remove('hide')
     }

    let sorted_body = document.createElement('tbody')
    sorted_body.classList.add('sort-body')

    console.log(sorted_body)
    console.log(body.parentNode)

    for (var m = 0; m < sortedRows.length; m++) {
      sorted_body.appendChild(sortedRows[m])
    }

    body.parentNode.replaceChild(sorted_body, body)
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
