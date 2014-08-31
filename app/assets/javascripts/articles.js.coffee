$ ->
  # tagging
  bhTags = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    limit: 10,
    dupDetector: (remoteMatch, localMatch) ->
      remoteMatch.id == localMatch.id
    ,
    # prefetch: {
    #   url: '/tags/list.json',
    #   ttl: 5000
    # },
    remote: '/tags/list.json?q=%QUERY'
  });

  bhTags.initialize()

  $("input.js-tag-names").tokenfield({
    typeahead: [
       {
        hint: true,
        highlight: true,
        minLength: 1
      },
      {
        name: 'tagName',
        displayKey: 'name',
        source: bhTags.ttAdapter(),
        templates: {
          suggestion: Handlebars.compile('<p><strong>{{name}}</strong> ({{taggings_count}})</p>')
        }
      }
    ]
  });

