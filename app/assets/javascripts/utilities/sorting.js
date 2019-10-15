document.addEventListener('turbolinks:load', function() {
  //  https://caniuse.com
  // var control = document.querySelector('.sort-by-title')
  // console.log(control)
  // if (control) {
  //   control.addEventListener('click', sortRowsByTitle)
  // }

  // var target;

  var control = document.querySelector('.tab-sorted') // getElementsByName('tab-sorted')

  if (control) {
    var thead = control.getElementsByTagName('thead')[0]
    // console.log(thead)
    var th_control = thead.querySelector('.sort-by-title')
    // console.log(th_control)
    if (th_control) {
        th_control.addEventListener('click', sortRowsByTitle())
      }
    }


//===============
  // if (control) {
  //     var head =  control.getElementsByTagName('thead')[0]
  //     console.log(head);
  //     control.onclick = function(event) {
  //     var target = event.target;
  //     console.log(target);
  //     console.log(target.classList);
  //     if (target.classList.contains('sort-by-title')) {
  //       console.log('SUCCSESSFULL!')
  //     }
  //     else {
  //       console.log('===?????====')
  //     }

  //   }
  // };
//==============
// head.rows[0].parentElement.tagName == "THEAD"

});



// function myFunction(control){
//     // control.onclick = function(event) {
//     console.log(control)
//     // control.onclick = function(event){
//     // var target = control.target; // где был клик?

//     console.log(target)
//   // };
// }

function sortRowsByTitle() {
  var table = document.querySelector('.tab-sorted')
  console.log(table)
        // var body =  document.querySelector('.sort-body')  //  table[0].getElementsByTagName('tbody')
  var body = table.getElementsByTagName('tbody')[0]
  console.log(body)

  // // body = document.querySelector('.tab-sorted').getElementsByTagName('tbody')[0]

  // NodeList
  // https://developer.mozilla.org/ru/docs/Web/API/NodeList

  var rows = body.querySelectorAll('tr') // [0].children
  console.log(rows[0])

  var sortedRows = []
  // Select all rows body
  for (var i = 0; i < rows.length; i++) {
      sortedRows.push(rows[i])
  }
  var head =  table.getElementsByTagName('thead')[0]
  console.log(head)
  var head_length = head.rows[0].children.length
  console.log(head_length)
  // console.log(this)

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

  var   sorted_body = document.createElement('tbody')
  // sorted_body.classList.add('sort-body')

  console.log(sorted_body)
  console.log(body.parentNode)

  for (var m = 0; m < sortedRows.length; m++) {
    sorted_body.appendChild(sortedRows[m])
  }
  console.log(sorted_body)
  console.log(body.parentNode)
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
