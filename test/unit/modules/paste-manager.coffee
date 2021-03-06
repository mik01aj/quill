describe('PasteManager', ->
  it('_paste()', (done) ->
    container = $('#editor-container').get(0)
    container.innerHTML = '
      <div>
        <div>0123</div>
      </div>'
    quill = new Quill(container.firstChild)
    pasteManager = quill.getModule('paste-manager')
    quill.setSelection(2, 2)
    pasteManager._paste()
    pasteManager.container.innerHTML = '
      <b>Pasted</b>
      <div style="text-align: right;">Text</div>
    '
    quill.on(Quill.events.TEXT_CHANGE, (delta) ->
      expect(delta).toEqualDelta(Quill.Delta.makeDelta({
        startLength: 5
        endLength: 16
        ops: [
          { start: 0, end: 2 }
          { value: 'Pasted', attributes: { bold: true } }
          { value: '\nText' }
          { start: 2, end: 5 }
        ]
      }))
      _.defer( ->
        range = quill.getSelection()
        expect(range.start).toEqual(13)
        expect(range.end).toEqual(13)
        done()
      )
    )
  )
)
