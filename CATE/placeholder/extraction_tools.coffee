###############################################################################
# CATE Homepage
# html - A jQuery object representing the page body
###############################################################################
extract_main_page_data = (html) ->
  
  version = html.find('table:first td:first').text()
  profile_image_src = html.find('table:eq(2) table:eq(1) tr:eq(0) img').attr('src')

  profile_fields = html.find('table:eq(2) table:eq(1) tr:eq(1) td').map (i, e) -> $(e).text()
  first_name = profile_fields[0]
  last_name = profile_fields[1]
  login = profile_fields[2]
  category = profile_fields[3]
  candidate_number = profile_fields[4]
  cid = profile_fields[5]
  personal_tutor = profile_fields[6]

  available_years = html.find('select[name=newyear] option').map (index, elem) ->
    elem = $(elem)
    {text: elem.html(), href: elem.attr('value')}
  available_years = available_years.slice(1)

  other_func_links = html.find('table:eq(2) table:eq(9) tr td:nth-child(3) a').map (index, elem) ->
    $(elem).attr('href')

  grading_schema_link = other_func_links[0]
  documentation_link = other_func_links[1]
  extensions_link = other_func_links[2]
  projects_portal_link = other_func_links[3]
  individual_records_link = other_func_links[4]

  default_class = html.find('input[name=class]:checked').val()
  default_period = html.find('input[name=period]:checked').val()

  keyt = html.find('input[type=hidden]').val()
  timetable_url = '/timetable.cgi?period=' + default_period + '&class=' + default_class + '&keyt=' + keyt

  return {
    version: version
    profile_image_src: profile_image_src
    first_name: first_name
    last_name: last_name
    login: login
    category: category
    candidate_number: candidate_number
    cid: cid
    personal_tutor: personal_tutor
    available_years: available_years
    grading_schema_link: grading_schema_link
    documentation_link: documentation_link
    extensions_link: extensions_link
    projects_portal_link: projects_portal_link
    individual_records_link: individual_records_link
    default_class: default_class
    default_period: default_period
    keyt: keyt
    timetable_url: timetable_url
  }

window.process_main_xml = ->

  vars = extract_main_page_data $('#main_page_xml')

  xml = $('<data/>')
  for own key, value of vars
    if key == 'available_years'
      year = $('<year/>').appendTo xml
      for v in value
        $('<year/>').append("<y>#{v.text}</y><a>#{v.href}</a>").appendTo year 
    else xml.append $("<#{key}/>").html(value)
  return xml.wrap('p').parent().html()



###############################################################################
# Excercise Page
# html - A jQuery object representing the page body
###############################################################################
extract_exercise_page_data = (html) ->

  # Extracts full title e.g. Spring Term 2012-2013
  extract_term_title = (html) ->
    html.find('tr').eq(0).find('h1').eq(0).text()

  # Converts a CATE style date into a JS Date object
  # e.g. '2013-1-7' -> Mon Jan 07 2013 00:00:00 GMT+0000 (GMT)
  parse_date = (input) ->
    [year, month, day] = input.match(/(\d+)/g)
    new Date(year, month - 1, day) # JS months index from 0

  # Extracts the academic years applicable
  # e.g. "Easter Period 2012-2013" -> ["2012", "2013"]
  extract_academic_years = (body) ->
    body.find('h1').text()[-9..].split('-')

  extract_start_end_dates = (fullTable, years) ->
    # Converts a month into an int (indexed from 1)
    # e.g. "January" -> 1
    # month - Month name as a capitalised string
    month_to_int = (m) ->
      months = ['January', 'February', 'March', 'April', 'May', 'June', 'July',
                'August', 'September', 'October', 'November', 'December']
      return 6 if m == 'J'
      rexp = new RegExp(m,'g')
      for month,i in months
            if rexp.test(month) then return i+1

    # Extracts months from table row
    # e.g. ["January", "February", "March"]
    # table_row - The Timetable table row jQuery Object
    extract_months = (table_row) ->
      table_headers = ($(cell) for cell in table_row.find('th'))
      month_cells = (c for c in table_headers when c.attr('bgcolor') == "white")
      month_names = (c.text().replace(/\s+/g, '') for c in month_cells)
      month_ids = month_names.map month_to_int
      return month_ids

    # Extracts days from table row
    # e.g. ["1", "2", "3"]
    # table_row - The Timetable table row jQuery Object
    extract_days = (table_row) ->
      table_headers = ($(cell) for cell in table_row.find('th'))
      days_text = (c.text() for c in table_headers)
      valid_days = (d for d in days_text when d.replace(/\s+/g, '') != '') 
      days_as_ints = valid_days.map parseFloat # Parse int was going nuts, '23' -> 54???
      return days_as_ints

    # TODO: What if the timetable crosses year boundaries?
    #       e.g over new year/christmas?

    [first_month, others..., last_month] = extract_months $(fullTable).find('tr').eq(0)

    year = if first_month < 9 then years[1] else years[0]

    day_headers = $(fullTable).find('tr').eq(2).find('th')

    col_buf = 0
    col_buf += 1 while $(day_headers[col_buf]).is(":empty")

    [first_day, others..., last_day] = extract_days $(fullTable).find('tr').eq(2)

    return {  # remember _day in yyyy-mm-dd format
      start: year + '-' + first_month + '-' + first_day
      end: year + '-' + last_month + '-' + last_day
      colBufferToFirst: col_buf - 1
    }

  # Extracts module details from a cell jQuery object
  process_module_cell = (cell) ->
    [id, name] = cell.text().split(' - ')
    return {
      id : id
      name : name.replace(/^\s+|\s+$/g, '')
      notesLink : cell.find('a').eq(0).attr('href')
    }

  # Add the parsed exercises to the given module
  # module - the module to attach the exercises to
  # exercise_cells - An array of cells (jQuery objects)
  process_exercises_from_cells = (module, exercise_cells) ->
    if not exercise_cells? then return null
    module.exercises ?= []

    current_date = parse_date dates.start
    current_date.setDate(current_date.getDate() - dates.colBufferToFirst)
    for ex_cell in exercise_cells
      colSpan = parseInt $(ex_cell).attr('colspan')
      if $(ex_cell).attr('bgcolor')? and $(ex_cell).find('a').length != 0
        [id, type] = $(ex_cell).find('b').eq(0).text().split(':')
        hrefs = ($(anchor).attr('href') for anchor in $(ex_cell).find('a') when $(anchor).attr('href')?)
        [mailto, spec, givens, handin] = [null, null, null, null]
        for href in hrefs
          if /mailto/i.test(href)
            mailto = href
          else if /SPECS/i.test(href)
            spec = href
          else if /given/i.test(href)
            givens = href
          else if /handins/i.test(href)
            handin = href

        end = new Date(current_date.getTime())
        end.setDate(end.getDate() + colSpan - 1)
        exercise_data = {
          id : id, type : type, start : new Date(current_date.getTime())
          end : end, moduleName : module.name
          name : $(ex_cell).text()[(id.length + type.length + 2)..].replace(/^\s+|\s+$/g,'')
          mailto : mailto, spec : spec, givens : givens, handin : handin
        }

        module.exercises.push(exercise_data)
      current_date.setDate (current_date.getDate() + colSpan)

  extract_module_exercise_data = (fullTable) ->

    # Returns whether or not an element is a module container
    # elem - jQuery element
    is_module = (elem) ->
      elem.find('font').attr('color') == "blue"

    allRows = $(fullTable).find('tr')
    modules = []
    count = 0
    while count < allRows.length
      current_row = allRows[count]
      following_row_count = 0
      module_elem = $($(current_row).find('td').eq(1))
      if is_module(module_elem)
        module_data = process_module_cell module_elem

        following_row_count = $(current_row).find('td').eq(0).attr('rowspan') - 1
        following_rows = allRows[count+1..count+following_row_count]

        exerciseCells = ($(row).find('td')[1..] for row in following_rows)
        exerciseCells.push($(current_row).find('td')[4..])
        exerciseCells = (cs for cs in exerciseCells when cs?)

        process_exercises_from_cells(module_data, cells) for cells in exerciseCells

        modules.push module_data
      count += following_row_count + 1
    return modules

  term_title = extract_term_title html
  timetable = (tb for tb in html.find('table') when $(tb).attr('border') == "0")
  dates = extract_start_end_dates timetable, extract_academic_years html   # WRONG
  modules = extract_module_exercise_data timetable
  m.exercises.sort ((a,b) -> if a.start < b.start then -1 else 1) for m in modules
  return {
    modules : modules
    start : dates.start, end : dates.end
    term_title : term_title
  }



window.process_exercise_xml = ->

  format_date = (d) ->
    d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate()

  vars = extract_exercise_page_data $('#exercise_page_xml')

  xml = $('<data/>')
  xml.append $('<term_title/>').html(vars.term_title),  
             $('<start/>').html(vars.start),
             $('<end/>').html(vars.end)
  for module,i in vars.modules
    m = $("<module/ num='#{i}'>").appendTo xml
    m.append $('<id/>').html(module.id), $('<name/>').html(module.name), 
             $('<notesLink/>').html(module.notesLink),
             (exs = $('<exercises/>'))
    for exercise,i in module.exercises
      $("<exercise/ num='#{i}'>").appendTo(exs)
        .append $('<id/>').html(exercise.id), $('<type/>').html(exercise.type),
                $('<start/>').html(format_date exercise.start),
                $('<end/>').html(format_date exercise.end),
                $('<moduleName/>').html(exercise.moduleName),
                $('<name/>').html(exercise.name),
                $('<mailto/>').html(exercise.mailto),
                $('<spec/>').html(exercise.spec),
                $('<givens/>').html(exercise.givens),
                $('<handin/>').html(exercise.handin)
    
  return xml.wrap('p').parent().html()


###############################################################################
# Notes Page for Module
# html - A jQuery object representing the page body
###############################################################################
extract_notes_page_data = (html) ->

  process_notes_rows = (html) ->
    html.find('table [cellpadding="3"]').find('tr')[1..]

  notes = []
  for row in ($(r) for r in process_notes_rows html)
    title = row.find('td:eq(1)').text()
    link = $(row.find('td:eq(1) a'))
    if link.attr('href')? && link.attr('href') != ''
      notes.push {
        type: "resource"
        title: title
        link: link.attr('href')
      }
    else if link.attr('onclick')? # Remote page
      identifier = link.attr('onclick').match(/clickpage\((.*)\)/)[1]
      href = "showfile.cgi?key=2012:3:#{identifier}:c3:NOTES:peh10"
      notes.push {
        type: "url"
        title : title
        link : href
      }

  return { notes: notes }


###############################################################################
# Givens Page for Exercise
# html - A jQuery object representing the page body
###############################################################################
extract_givens_page_data = (html) ->

  categories = []

  # Select the tables
  html.find('table [cellpadding="3"]')[2..].each(->
    category = {}
    if $(this).find('tr').length > 1  # Only process tables with content
      category.type = $(this).closest('form').find('h3 font').html()[..-2]
      rows = $(this).find('tr')[1..]
      category.givens = []
      for row in rows
        if (cell = $(row).find('td:eq(0) a')).attr('href')?
          category.givens.push {
            title : cell.html()
            link  : cell.attr('href')
          }
      categories.push category
    )    

  # Return an array of categories, each element containing a type and rows
  # categories = [ { type = 'TYPE', givens = [{title, link}] } ]
  return categories


###############################################################################
# Project Portal Page
# html - A jQuery object representing the page body
###############################################################################
extract_project_page_data = (html) ->

  process_module_row = (row, a) ->
    [mod_cell, class_cell] = 
      if a? then a
      else [row.find('td:eq(0)'), row.find('td:eq(1)')]

    [mod_id, others...] = $(mod_cell).text().split(' - ')
    mod_name = others.reduce (a,b) -> a + ' - ' + b

    return {
      id : mod_id
      name : mod_name 
      classes : ($(c).text() for c in $(class_cell).find('font'))
    }

  rows = ($(r) for r in html.find('table[border="1"]:eq(0) tr'))
  projects = []

  console.log "SCRAPING #{rows.length} ROWS"
  i = 0
  while i < rows.length

    if rows[i].find('td[bgcolor="white"]').length != 0
      project = {}
      
      project.title       = rows[i].find('td:eq(0)').text()
      project.organiser   = rows[i].find('td:eq(1)').text()
      project.info_link   = rows[i].find('td:eq(4) a:eq(0)').attr 'href'
      project.admin_link  = rows[i].find('td:eq(5) a:eq(0)').attr 'href'
      project.modules     = []

      offset = parseFloat(rows[i].find('td:eq(0)').attr('rowspan')) - 1
      
      project.modules.push \
        process_module_row null, ($(c) for c in rows[i].find('td')[2..3])

      if offset != 0 then for i in [1+i..i+offset-1]
        project.modules.push process_module_row rows[i]
      for m in project.modules
        console.log 'ID : ' + m.id + '\nName : ' + m.name + '\nClasses : ' + m.classes.toString()
      projects.push project  
    i++

  return projects

###############################################################################
# Grades/Student Record Page
# html - A jQuery object representing the page body
###############################################################################
extract_grades_page_data = (html) ->
  process_header_row = (row) ->
    # TODO: Regex out the fluff
    return {
      name: text_extract row.find('td:eq(0)')
      term: text_extract row.find('td:eq(1)')
      submission: text_extract row.find('td:eq(2)')
      level: text_extract row.find('td:eq(3)')
      exercises: []
    }

  process_grade_row = (row) ->
    return {
      id: parseInt(text_extract row.find('td:eq(0)'))
      type: text_extract row.find('td:eq(1)')
      title: text_extract row.find('td:eq(2)')
      set_by: text_extract row.find('td:eq(3)')
      declaration: text_extract row.find('td:eq(4)')
      extension: text_extract row.find('td:eq(5)')
      submission: text_extract row.find('td:eq(6)')
      grade: text_extract row.find('td:eq(7)')
    }

  extract_modules = (table) ->
    grade_rows = table.find('tr')
    grade_rows = grade_rows.slice(2)

    modules = []
    current_module = null;
    grade_rows.each (i, e) ->
      row_elem = $(e)
      tds = row_elem.find('td')
      if tds.length > 1 # Ignore spacer/empty rows
        if $(tds[0]).attr('colspan')
          current_module = process_header_row(row_elem)
          modules.push current_module
        else
          current_module.exercises.push process_grade_row(row_elem)

    return modules

  # TODO: Regex extract useful values
  subscription_last_updated = text_extract html.find('table:eq(7) table td:eq(1)')
  submissions_completed = text_extract html.find('table:eq(7) table td:eq(4)')
  submissions_extended = text_extract html.find('table:eq(7) table td:eq(6)')
  submissions_late = text_extract html.find('table:eq(7) table td:eq(8)')

  required_modules = extract_modules html.find('table:eq(9)')
  optional_modules = extract_modules html.find('table:eq(-2)')

  return {
    stats:
      subscription_last_updated: subscription_last_updated
      submissions_completed: submissions_completed
      submissions_extended: submissions_extended
      submissions_late: submissions_late
    required_modules: required_modules
    optional_modules: optional_modules
  }