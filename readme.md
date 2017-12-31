vim-hanami
==========

Plugin to help with development of hanami applications. Install as usual

```
Plug 'graywolf/vim-hanami'
```

It has six commands at the moment

```
HanamiGoToSpec
HanamiGoFromSpec
HanamiToggleSpec

HanamiGoToController
HanamiGoToView
HanamiGoToTemplate
```

First trio

```
+----------------+  HanamiGoToSpec  +------+
|                | ---------------> |      |
| Implementation |                  | Spec |
|                | <--------------- |      |
+----------------+ HanamiGoFromSpec +------+
```

As for `HanamiToggleSpec` that's basically just

```ruby
if is_spec?
  HanamiGoFromSpec
else
  HanamiGoToSpec
end
```

As for the rest

```
                          +------------------------+  HanamiGoToController
                      +---| Controller (Spec/Impl) | <--------------+
                      |   +------------------------+                |
                      |                           |                 |
                      |                           |                 |
                      |   +------------------+----|-----------------+
   HanamiGoToTemplate +---| View (Spec/Impl) | <--+ HanamiGoToView  |
                      |   +------------------+    |                 |
                      |                           |                 |
                      |                           |                 |
                      |   +-----------------+     |                 |
                      +-> | Template (Impl) + ----+                 |
                          +-----------------+-----------------------+
```

All "go" actions doesn't switch between spec/impl, so if you are on spec for
a controller and do `HanamiGoToView`, you will end up on the spec for a view.

`HanamiGoToTemplate` is a bit special since there is no spec for template, so
you will always end up on the impl.

vimrc
-----

It's also probably useful to add some mappings to .vimrc:

```vimscript
" mappings for vim-hanami
map <leader>hs :HanamiToggleSpec<CR>
map <leader>hc :HanamiGoToController<CR>
map <leader>hv :HanamiGoToView<CR>
map <leader>ht :HanamiGoToTemplate<CR>
```
