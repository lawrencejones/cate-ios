load_cate_page = function(url, callback) {
  ifm = document.createElement('IFRAME');
  $(ifm).attr({'src':url,'name':'CATE'})
  	.appendTo('html')
  	.load(function () {
  		alert('Finished loading!');
  		console.log(frames['CATE'].window.document); //.find('body').appendTo($(document.body));
  	});
};

extract_main_page_data = function(html) {
  var available_years, candidate_number, category, cid, current_url, current_user, current_year, default_class, default_period, documentation_link, extensions_link, first_name, grading_schema_link, individual_records_link, keyt, last_name, login, other_func_links, personal_tutor, profile_fields, profile_image_src, projects_portal_link, timetable_url, version;
  current_url = document.URL;
  current_year = current_url.match("keyp=([0-9]+)")[1];
  current_user = current_url.match("[0-9]+:(.*)")[1];
  version = html.find('table:first td:first').text();
  profile_image_src = html.find('table:eq(2) table:eq(1) tr:eq(0) img').attr('src');
  profile_fields = html.find('table:eq(2) table:eq(1) tr:eq(1) td').map(function(i, e) {
    return $(e).text();
  });
  first_name = profile_fields[0];
  last_name = profile_fields[1];
  login = profile_fields[2];
  category = profile_fields[3];
  candidate_number = profile_fields[4];
  cid = profile_fields[5];
  personal_tutor = profile_fields[6];
  available_years = html.find('select[name=newyear] option').map(function(index, elem) {
    elem = $(elem);
    return {
      text: elem.html(),
      href: elem.attr('value')
    };
  });
  available_years = available_years.slice(1);
  other_func_links = html.find('table:eq(2) table:eq(9) tr td:nth-child(3) a').map(function(index, elem) {
    return $(elem).attr('href');
  });
  grading_schema_link = other_func_links[0];
  documentation_link = other_func_links[1];
  extensions_link = other_func_links[2];
  projects_portal_link = other_func_links[3];
  individual_records_link = other_func_links[4];
  default_class = html.find('input[name=class]:checked').val();
  default_period = html.find('input[name=period]:checked').val();
  keyt = html.find('input[type=hidden]').val();
  timetable_url = '/timetable.cgi?period=' + default_period + '&class=' + default_class + '&keyt=' + keyt;
  return {
    current_url: current_url,
    current_year: current_year,
    current_user: current_user,
    version: version,
    profile_image_src: profile_image_src,
    first_name: first_name,
    last_name: last_name,
    login: login,
    category: category,
    candidate_number: candidate_number,
    cid: cid,
    personal_tutor: personal_tutor,
    available_years: available_years,
    grading_schema_link: grading_schema_link,
    documentation_link: documentation_link,
    extensions_link: extensions_link,
    projects_portal_link: projects_portal_link,
    individual_records_link: individual_records_link,
    default_class: default_class,
    default_period: default_period,
    keyt: keyt,
    timetable_url: timetable_url
  };
};

extract_exercise_page_data = function(html) {
  var dates, extract_academic_years, extract_module_exercise_data, extract_start_end_dates, extract_term_title, m, modules, parse_date, process_exercises_from_cells, process_module_cell, tb, term_title, timetable, _i, _len;
  extract_term_title = function(html) {
    return html.find('tr').eq(0).find('h1').eq(0).text();
  };
  parse_date = function(input) {
    var day, month, year, _ref;
    _ref = input.match(/(\d+)/g), year = _ref[0], month = _ref[1], day = _ref[2];
    return new Date(year, month - 1, day);
  };
  extract_academic_years = function(body) {
    return body.find('h1').text().slice(-9).split('-');
  };
  extract_start_end_dates = function(fullTable, years) {
    var col_buf, day_headers, extract_days, extract_months, first_day, first_month, last_day, last_month, month_to_int, others, year, _i, _j, _ref, _ref1;
    month_to_int = function(m) {
      var i, month, months, rexp, _i, _len;
      months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      if (m === 'J') {
        return 6;
      }
      rexp = new RegExp(m, 'g');
      for (i = _i = 0, _len = months.length; _i < _len; i = ++_i) {
        month = months[i];
        if (rexp.test(month)) {
          return i + 1;
        }
      }
    };
    extract_months = function(table_row) {
      var c, cell, month_cells, month_ids, month_names, table_headers;
      table_headers = (function() {
        var _i, _len, _ref, _results;
        _ref = table_row.find('th');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          cell = _ref[_i];
          _results.push($(cell));
        }
        return _results;
      })();
      month_cells = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = table_headers.length; _i < _len; _i++) {
          c = table_headers[_i];
          if (c.attr('bgcolor') === "white") {
            _results.push(c);
          }
        }
        return _results;
      })();
      month_names = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = month_cells.length; _i < _len; _i++) {
          c = month_cells[_i];
          _results.push(c.text().replace(/\s+/g, ''));
        }
        return _results;
      })();
      month_ids = month_names.map(month_to_int);
      return month_ids;
    };
    extract_days = function(table_row) {
      var c, cell, d, days_as_ints, days_text, table_headers, valid_days;
      table_headers = (function() {
        var _i, _len, _ref, _results;
        _ref = table_row.find('th');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          cell = _ref[_i];
          _results.push($(cell));
        }
        return _results;
      })();
      days_text = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = table_headers.length; _i < _len; _i++) {
          c = table_headers[_i];
          _results.push(c.text());
        }
        return _results;
      })();
      valid_days = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = days_text.length; _i < _len; _i++) {
          d = days_text[_i];
          if (d.replace(/\s+/g, '') !== '') {
            _results.push(d);
          }
        }
        return _results;
      })();
      days_as_ints = valid_days.map(parseFloat);
      return days_as_ints;
    };
    _ref = extract_months($(fullTable).find('tr').eq(0)), first_month = _ref[0], others = 3 <= _ref.length ? __slice.call(_ref, 1, _i = _ref.length - 1) : (_i = 1, []), last_month = _ref[_i++];
    year = first_month < 9 ? years[1] : years[0];
    day_headers = $(fullTable).find('tr').eq(2).find('th');
    col_buf = 0;
    while ($(day_headers[col_buf]).is(":empty")) {
      col_buf += 1;
    }
    _ref1 = extract_days($(fullTable).find('tr').eq(2)), first_day = _ref1[0], others = 3 <= _ref1.length ? __slice.call(_ref1, 1, _j = _ref1.length - 1) : (_j = 1, []), last_day = _ref1[_j++];
    return {
      start: year + '-' + first_month + '-' + first_day,
      end: year + '-' + last_month + '-' + last_day,
      colBufferToFirst: col_buf - 1
    };
  };
  process_module_cell = function(cell) {
    var id, name, _ref;
    _ref = cell.text().split(' - '), id = _ref[0], name = _ref[1];
    return {
      id: id,
      name: name.replace(/^\s+|\s+$/g, ''),
      notesLink: cell.find('a').eq(0).attr('href')
    };
  };
  process_exercises_from_cells = function(module, exercise_cells) {
    var anchor, colSpan, current_date, end, ex_cell, exercise_data, givens, handin, href, hrefs, id, mailto, spec, type, _i, _j, _len, _len1, _ref, _ref1, _ref2, _results;
    if (!(exercise_cells != null)) {
      return null;
    }
    if ((_ref = module.exercises) == null) {
      module.exercises = [];
    }
    current_date = parse_date(dates.start);
    current_date.setDate(current_date.getDate() - dates.colBufferToFirst);
    _results = [];
    for (_i = 0, _len = exercise_cells.length; _i < _len; _i++) {
      ex_cell = exercise_cells[_i];
      colSpan = parseInt($(ex_cell).attr('colspan'));
      if (($(ex_cell).attr('bgcolor') != null) && $(ex_cell).find('a').length !== 0) {
        _ref1 = $(ex_cell).find('b').eq(0).text().split(':'), id = _ref1[0], type = _ref1[1];
        hrefs = (function() {
          var _j, _len1, _ref2, _results1;
          _ref2 = $(ex_cell).find('a');
          _results1 = [];
          for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
            anchor = _ref2[_j];
            if ($(anchor).attr('href') != null) {
              _results1.push($(anchor).attr('href'));
            }
          }
          return _results1;
        })();
        _ref2 = [null, null, null, null], mailto = _ref2[0], spec = _ref2[1], givens = _ref2[2], handin = _ref2[3];
        for (_j = 0, _len1 = hrefs.length; _j < _len1; _j++) {
          href = hrefs[_j];
          if (/mailto/i.test(href)) {
            mailto = href;
          } else if (/SPECS/i.test(href)) {
            spec = href;
          } else if (/given/i.test(href)) {
            givens = href;
          } else if (/handins/i.test(href)) {
            handin = href;
          }
        }
        end = new Date(current_date.getTime());
        end.setDate(end.getDate() + colSpan - 1);
        exercise_data = {
          id: id,
          type: type,
          start: new Date(current_date.getTime()),
          end: end,
          moduleName: module.name,
          name: $(ex_cell).text().slice(id.length + type.length + 2).replace(/^\s+|\s+$/g, ''),
          mailto: mailto,
          spec: spec,
          givens: givens,
          handin: handin
        };
        module.exercises.push(exercise_data);
      }
      _results.push(current_date.setDate(current_date.getDate() + colSpan));
    }
    return _results;
  };
  extract_module_exercise_data = function(fullTable) {
    var allRows, cells, count, cs, current_row, exerciseCells, following_row_count, following_rows, is_module, module_data, module_elem, modules, row, _i, _len;
    is_module = function(elem) {
      return elem.find('font').attr('color') === "blue";
    };
    allRows = $(fullTable).find('tr');
    modules = [];
    count = 0;
    while (count < allRows.length) {
      current_row = allRows[count];
      following_row_count = 0;
      module_elem = $($(current_row).find('td').eq(1));
      if (is_module(module_elem)) {
        module_data = process_module_cell(module_elem);
        following_row_count = $(current_row).find('td').eq(0).attr('rowspan') - 1;
        following_rows = allRows.slice(count + 1, +(count + following_row_count) + 1 || 9e9);
        exerciseCells = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = following_rows.length; _i < _len; _i++) {
            row = following_rows[_i];
            _results.push($(row).find('td').slice(1));
          }
          return _results;
        })();
        exerciseCells.push($(current_row).find('td').slice(4));
        exerciseCells = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = exerciseCells.length; _i < _len; _i++) {
            cs = exerciseCells[_i];
            if (cs != null) {
              _results.push(cs);
            }
          }
          return _results;
        })();
        for (_i = 0, _len = exerciseCells.length; _i < _len; _i++) {
          cells = exerciseCells[_i];
          process_exercises_from_cells(module_data, cells);
        }
        modules.push(module_data);
      }
      count += following_row_count + 1;
    }
    return modules;
  };
  term_title = extract_term_title(html);
  timetable = (function() {
    var _i, _len, _ref, _results;
    _ref = html.find('table');
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tb = _ref[_i];
      if ($(tb).attr('border') === "0") {
        _results.push(tb);
      }
    }
    return _results;
  })();
  dates = extract_start_end_dates(timetable, extract_academic_years(html));
  modules = extract_module_exercise_data(timetable);
  for (_i = 0, _len = modules.length; _i < _len; _i++) {
    m = modules[_i];
    m.exercises.sort((function(a, b) {
      if (a.start < b.start) {
        return -1;
      } else {
        return 1;
      }
    }));
  }
  return {
    modules: modules,
    start: dates.start,
    end: dates.end,
    term_title: term_title
  };
};

extract_notes_page_data = function(html) {
  var href, identifier, link, notes, process_notes_rows, r, row, title, _i, _len, _ref;
  process_notes_rows = function(html) {
    return html.find('table [cellpadding="3"]').find('tr').slice(1);
  };
  notes = [];
  _ref = (function() {
    var _j, _len, _ref, _results;
    _ref = process_notes_rows(html);
    _results = [];
    for (_j = 0, _len = _ref.length; _j < _len; _j++) {
      r = _ref[_j];
      _results.push($(r));
    }
    return _results;
  })();
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    row = _ref[_i];
    title = row.find('td:eq(1)').text();
    link = $(row.find('td:eq(1) a'));
    if ((link.attr('href') != null) && link.attr('href') !== '') {
      notes.push({
        type: "resource",
        title: title,
        link: link.attr('href')
      });
    } else if (link.attr('onclick') != null) {
      identifier = link.attr('onclick').match(/clickpage\((.*)\)/)[1];
      href = "showfile.cgi?key=2012:3:" + identifier + ":c3:NOTES:peh10";
      notes.push({
        type: "url",
        title: title,
        link: href
      });
    }
  }
  return {
    notes: notes
  };
};

extract_givens_page_data = function(html) {
  var categories;
  categories = [];
  html.find('table [cellpadding="3"]').slice(2).each(function() {
    var category, cell, row, rows, _i, _len;
    category = {};
    if ($(this).find('tr').length > 1) {
      category.type = $(this).closest('form').find('h3 font').html().slice(0, -1);
      rows = $(this).find('tr').slice(1);
      category.givens = [];
      for (_i = 0, _len = rows.length; _i < _len; _i++) {
        row = rows[_i];
        if ((cell = $(row).find('td:eq(0) a')).attr('href') != null) {
          category.givens.push({
            title: cell.html(),
            link: cell.attr('href')
          });
        }
      }
      return categories.push(category);
    }
  });
  return categories;
};

extract_project_page_data = function(html) {
  var c, i, m, offset, process_module_row, project, projects, r, rows, _i, _j, _len, _ref, _ref1, _ref2;
  process_module_row = function(row, a) {
    var c, class_cell, mod_cell, mod_id, mod_name, others, _ref, _ref1;
    _ref = a != null ? a : [row.find('td:eq(0)'), row.find('td:eq(1)')], mod_cell = _ref[0], class_cell = _ref[1];
    _ref1 = $(mod_cell).text().split(' - '), mod_id = _ref1[0], others = 2 <= _ref1.length ? __slice.call(_ref1, 1) : [];
    mod_name = others.reduce(function(a, b) {
      return a + ' - ' + b;
    });
    return {
      id: mod_id,
      name: mod_name,
      classes: (function() {
        var _i, _len, _ref2, _results;
        _ref2 = $(class_cell).find('font');
        _results = [];
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          c = _ref2[_i];
          _results.push($(c).text());
        }
        return _results;
      })()
    };
  };
  rows = (function() {
    var _i, _len, _ref, _results;
    _ref = html.find('table[border="1"]:eq(0) tr');
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      r = _ref[_i];
      _results.push($(r));
    }
    return _results;
  })();
  projects = [];
  console.log("SCRAPING " + rows.length + " ROWS");
  i = 0;
  while (i < rows.length) {
    if (rows[i].find('td[bgcolor="white"]').length !== 0) {
      project = {};
      project.title = rows[i].find('td:eq(0)').text();
      project.organiser = rows[i].find('td:eq(1)').text();
      project.info_link = rows[i].find('td:eq(4) a:eq(0)').attr('href');
      project.admin_link = rows[i].find('td:eq(5) a:eq(0)').attr('href');
      project.modules = [];
      offset = parseFloat(rows[i].find('td:eq(0)').attr('rowspan')) - 1;
      project.modules.push(process_module_row(null, (function() {
        var _i, _len, _ref, _results;
        _ref = rows[i].find('td').slice(2, 4);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          c = _ref[_i];
          _results.push($(c));
        }
        return _results;
      })()));
      if (offset !== 0) {
        for (i = _i = _ref = 1 + i, _ref1 = i + offset - 1; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; i = _ref <= _ref1 ? ++_i : --_i) {
          project.modules.push(process_module_row(rows[i]));
        }
      }
      _ref2 = project.modules;
      for (_j = 0, _len = _ref2.length; _j < _len; _j++) {
        m = _ref2[_j];
        console.log('ID : ' + m.id + '\nName : ' + m.name + '\nClasses : ' + m.classes.toString());
      }
      projects.push(project);
    }
    i++;
  }
  return projects;
};

extract_grades_page_data = function(html) {
  var extract_modules, optional_modules, process_grade_row, process_header_row, required_modules, submissions_completed, submissions_extended, submissions_late, subscription_last_updated;
  process_header_row = function(row) {
    return {
      name: text_extract(row.find('td:eq(0)')),
      term: text_extract(row.find('td:eq(1)')),
      submission: text_extract(row.find('td:eq(2)')),
      level: text_extract(row.find('td:eq(3)')),
      exercises: []
    };
  };
  process_grade_row = function(row) {
    return {
      id: parseInt(text_extract(row.find('td:eq(0)'))),
      type: text_extract(row.find('td:eq(1)')),
      title: text_extract(row.find('td:eq(2)')),
      set_by: text_extract(row.find('td:eq(3)')),
      declaration: text_extract(row.find('td:eq(4)')),
      extension: text_extract(row.find('td:eq(5)')),
      submission: text_extract(row.find('td:eq(6)')),
      grade: text_extract(row.find('td:eq(7)'))
    };
  };
  extract_modules = function(table) {
    var current_module, grade_rows, modules;
    grade_rows = table.find('tr');
    grade_rows = grade_rows.slice(2);
    modules = [];
    current_module = null;
    grade_rows.each(function(i, e) {
      var row_elem, tds;
      row_elem = $(e);
      tds = row_elem.find('td');
      if (tds.length > 1) {
        if ($(tds[0]).attr('colspan')) {
          current_module = process_header_row(row_elem);
          return modules.push(current_module);
        } else {
          return current_module.exercises.push(process_grade_row(row_elem));
        }
      }
    });
    return modules;
  };
  subscription_last_updated = text_extract(html.find('table:eq(7) table td:eq(1)'));
  submissions_completed = text_extract(html.find('table:eq(7) table td:eq(4)'));
  submissions_extended = text_extract(html.find('table:eq(7) table td:eq(6)'));
  submissions_late = text_extract(html.find('table:eq(7) table td:eq(8)'));
  required_modules = extract_modules(html.find('table:eq(9)'));
  optional_modules = extract_modules(html.find('table:eq(-2)'));
  return {
    stats: {
      subscription_last_updated: subscription_last_updated,
      submissions_completed: submissions_completed,
      submissions_extended: submissions_extended,
      submissions_late: submissions_late
    },
    required_modules: required_modules,
    optional_modules: optional_modules
  };
};
