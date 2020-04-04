var SHARED_TOOLBAR_ACTIONS = [
    {
        label: 'Enable Reorder Mode',
        cssClasses: 'btn-default drag-toggle',
        onRender: function(btn, node, tree, toolbarRenderer) {
            if ($(tree.large_tree.elt).is('.drag-enabled')) {
                $(btn).addClass('active').addClass('btn-success');

                $(btn).text('Disable Reorder Mode');

                tree.ajax_tree.hide_form();
            }
        },
        onToolbarRendered: function(btn, toolbarRenderer) {
            if ($(tree.large_tree.elt).is('.drag-enabled')) {
                $('.btn:not(.drag-toggle,.finish-editing,.cut-selection,.paste-selection,.move-node)',toolbarRenderer.container).hide();
                $('.cut-selection',toolbarRenderer.container).removeClass('disabled');
                if ($('.cut', tree.large_tree.elt).length > 0) {
                    $('.paste-selection',toolbarRenderer.container).removeClass('disabled');
                }
            }
        },
        onClick: function(event, btn, node, tree, toolbarRenderer) {
            $(tree.large_tree.elt).toggleClass('drag-enabled');
            $(event.target).toggleClass('btn-success');

            if ($(tree.large_tree.elt).is('.drag-enabled')) {
                $(btn).text('Disable Reorder Mode');
                tree.ajax_tree.hide_form();
                $.scrollTo(0);
                tree.resizer.maximize(DRAGDROP_HOTSPOT_HEIGHT);
                $('.btn:not(.drag-toggle,.finish-editing)',toolbarRenderer.container).hide();
                $('.cut-selection,.paste-selection,.move-node', toolbarRenderer.container).show();
                $('.cut-selection,.move-node',toolbarRenderer.container).removeClass('disabled');
            } else {
                $(btn).text('Enable Reorder Mode');
                tree.ajax_tree.show_form();
                tree.resizer.reset();
                $('.btn',toolbarRenderer.container).show();
                $('.cut-selection,.paste-selection,.move-node', toolbarRenderer.container).hide();
                $(btn).blur();
            }
        },
        isEnabled: function(node, tree, toolbarRenderer) {
            return true;
        },
        isVisible: function(node, tree, toolbarRenderer) {
            return !tree.large_tree.read_only;
        },
        onFormChanged: function(btn, form, tree, toolbarRenderer) {
            $(btn).addClass('disabled');
        },
        onFormLoaded: function(btn, form, tree, toolbarRenderer) {
            if ($(tree.large_tree.elt).is('.drag-enabled')) {
                tree.ajax_tree.blockout_form();
            }
        },
    },
    [
        {
            label: 'Cut',
            cssClasses: 'btn-default cut-selection',
            onRender: function(btn, node, tree, toolbarRenderer) {
                if (!$(tree.large_tree.elt).is('.drag-enabled')) {
                    btn.hide();
                }
            },
            onClick: function(event, btn, node, tree, toolbarRenderer) {
                event.preventDefault();
                // clear the previous cut set
                $('.cut', tree.large_tree.elt).removeClass('cut');

                var rowsToCut = [];
                if (tree.dragdrop.rowsToMove.length > 0) {
                    // if multiselected rows, cut them
                    rowsToCut = $.merge([], tree.dragdrop.rowsToMove);
                } else if (tree.current().is(':not(.root-row)')) {
                    // otherwise cut the current row
                    rowsToCut = [tree.current()];
                }

                if (rowsToCut.length > 0) {
                    $.each(rowsToCut, function(_, row) {
                        $(row).addClass('cut');
                    });

                    $('.paste-selection', toolbarRenderer.container).removeClass('disabled');
                }

                tree.dragdrop.resetState();
            },
            isEnabled: function(node, tree, toolbarRenderer) {
                return true;
            },
            isVisible: function(node, tree, toolbarRenderer) {
                return !tree.large_tree.read_only && tree.dragdrop;
            }
        },
        {
            label: 'Paste',
            cssClasses: 'btn-default paste-selection',
            onRender: function(btn, node, tree, toolbarRenderer) {
                if (!$(tree.large_tree.elt).is('.drag-enabled')) {
                    btn.hide();
                } else if ($('.cut', $(tree.large_tree.elt)).length == 0) {
                    btn.addClass('disabled');
                }
            },
            onClick: function(event, btn, node, tree, toolbarRenderer) {
                event.preventDefault();
                var current = tree.current();
                var cut = $('.cut', tree.large_tree.elt);

                var rowsToPaste = [];
                cut.each(function(_,row) {
                    if ($(row).data('uri') != current.data('uri')) {
                        rowsToPaste.push(row);
                    }
                });

                tree.large_tree.reparentNodes(current, rowsToPaste, current.data('child_count')).done(function() {
                    $('.cut', tree.large_tree.elt).removeClass('cut');
                    toolbarRenderer.reset();
                });
            },
            isEnabled: function(node, tree, toolbarRenderer) {
                return true;
            },
            isVisible: function(node, tree, toolbarRenderer) {
                return !tree.large_tree.read_only && tree.dragdrop;
            }
        },
    ],
    {
        label: 'Move <span class="caret"></span>',
        cssClasses: 'btn-default dropdown-toggle move-node',
        groupCssClasses: 'dropdown',
        onRender: function(btn, node, tree, toolbarRenderer) {
            if (!$(tree.large_tree.elt).is('.drag-enabled')) {
                btn.hide();
            }
            var level = node.data('level');
            var position = node.data('position');

            var $options = $('<ul>').addClass('dropdown-menu ');
            // move up a level
            if (level > 1) {
                var $li = $('<li>');
                $li.append($('<a>').attr('href', 'javascript:void(0);').
                                    addClass('move-node move-node-up-level').
                                    text('Up a Level'));
                $options.append($li);
            }

            var $prevAtLevel = node.prevAll('.largetree-node.indent-level-'+level+':first');
            var $nextAtLevel = node.nextAll('.largetree-node.indent-level-'+level+':first');

            // move up on same level
            if ($prevAtLevel.length > 0) {
                var $li = $('<li>');
                $li.append($('<a>').attr('href', 'javascript:void(0);')
                                   .addClass('move-node move-node-up')
                                   .text('Up'));
                $options.append($li);
            }
            // move down on same level
            if ($nextAtLevel.length > 0) {
                var $li = $('<li>');
                $li.append($('<a>').attr('href', 'javascript:void(0);')
                                   .addClass('move-node move-node-down')
                                   .text('Down'));
                $options.append($li);
            }
            // move down into sibling
            if ($prevAtLevel.length > 0 || $nextAtLevel.length > 0) {
                var $li = $('<li>').addClass('dropdown-submenu');
                $li.append($('<a>').attr('href', 'javascript:void(0);')
                    .text('Down Into...'));
                $options.append($li);

                var $siblingsMenu = $('<ul>').addClass('dropdown-menu').addClass('move-node-into-menu');

                var $siblingsAbove = $.makeArray(node.prevAll('.largetree-node.indent-level-'+level));
                var $siblingsBelow = $.makeArray(node.nextAll('.largetree-node.indent-level-'+level));

                var NUMBER_OF_SIBLINGS_TO_LIST = 20;
                var HALF_THE_NUMBER_OF_SIBLINGS_TO_LIST = parseInt(NUMBER_OF_SIBLINGS_TO_LIST/2);
                var $siblingsToAddToMenu = [];
                if ($siblingsAbove.length > HALF_THE_NUMBER_OF_SIBLINGS_TO_LIST && $siblingsBelow.length > HALF_THE_NUMBER_OF_SIBLINGS_TO_LIST) {
                    $siblingsToAddToMenu = $.merge($siblingsAbove.slice(0, HALF_THE_NUMBER_OF_SIBLINGS_TO_LIST ).reverse(),
                                                   $siblingsBelow.slice(0, HALF_THE_NUMBER_OF_SIBLINGS_TO_LIST));
                } else if ($siblingsAbove.length > HALF_THE_NUMBER_OF_SIBLINGS_TO_LIST) {
                    $siblingsToAddToMenu = $.merge($siblingsAbove.slice(0, NUMBER_OF_SIBLINGS_TO_LIST - $siblingsBelow.length).reverse(),
                                                   $siblingsBelow);
                } else if ($siblingsBelow.length > HALF_THE_NUMBER_OF_SIBLINGS_TO_LIST) {
                    $siblingsToAddToMenu = $.merge($siblingsAbove.reverse(),
                                                   $siblingsBelow.slice(0, NUMBER_OF_SIBLINGS_TO_LIST - $siblingsAbove.length));
                } else {
                    $siblingsToAddToMenu = $.merge($siblingsAbove.reverse(), $siblingsBelow);
                }

                for (var i = 0; i < $siblingsToAddToMenu.length; i++) {
                    var $sibling = $($siblingsToAddToMenu[i]);
                    var $subli = $('<li>');
                    $subli.append($('<a>').attr('href', 'javascript:void(0);')
                        .addClass('move-node move-node-down-into')
                        .attr('data-uri', $sibling.data('uri'))
                        .attr('data-tree_id', $sibling.attr('id'))
                        .text($sibling.find('.record-title').text().trim()));
                    $siblingsMenu.append($subli);
                }

                $siblingsMenu.appendTo($li);
            }
            $options.appendTo(btn.closest('.btn-group'));

            if ($options.is(':empty')) {
                // node has no parent or siblings so has nowhere to move
                // remove the toolbar action if this is the case
                btn.remove();
            }

            $options.on('click', '.move-node-up-level', function(event) {
                // move node to last child of parent
                var $new_parent = node.prevAll('.indent-level-'+(level-2)+":first");
                tree.large_tree.reparentNodes($new_parent, node, $new_parent.data('child_count')).done(function() {
                    toolbarRenderer.reset();
                });
            }).on('click', '.move-node-up', function(event) {
                // move node above nearest sibling
                var $parent = node.prevAll('.indent-level-'+(level-1)+":first");
                var $prev = node.prevAll('.indent-level-'+(level)+":first");
                tree.large_tree.reparentNodes($parent, node, $prev.data('position')).done(function() {
                    toolbarRenderer.reset();
                });
            }).on('click', '.move-node-down', function(event) {
                // move node below nearest sibling
                var $parent = node.prevAll('.indent-level-'+(level-1)+":first");
                var $next = node.nextAll('.indent-level-'+(level)+":first");
                tree.large_tree.reparentNodes($parent, node, $next.data('position')+1).done(function() {
                    toolbarRenderer.reset();
                });
            }).on('click', '.move-node-down-into', function(event) {
                // move node to last child of sibling
                var $parent = $('#'+$(this).data('tree_id'));
                tree.large_tree.reparentNodes($parent, node, $parent.data('child_count')).done(function() {
                    toolbarRenderer.reset();
                });
            });

            btn.attr('data-toggle', 'dropdown');
        },
        isEnabled: function(node, tree, toolbarRenderer) {
            return true;
        },
        isVisible: function(node, tree, toolbarRenderer) {
            // not available to root nodes
            if (node.is('.root-row')) {
                return false;
            }

            return !tree.large_tree.read_only && tree.dragdrop;
        },
    },
    // RDE
    {
        label: 'Rapid Data Entry',
        cssClasses: 'btn-default add-children',
        onClick: function(event, btn, node, tree, toolbarRenderer) {
            $(document).triggerHandler("rdeshow.aspace", [node, btn]);
        },
        isEnabled: function(node, tree, toolbarRenderer) {
            return true;
        },
        isVisible: function(node, tree, toolbarRenderer) {
            return !tree.large_tree.read_only;
        },
        onFormLoaded: function(btn, form, tree, toolbarRenderer) {
            $(btn).removeClass('disabled');
        },
        onToolbarRendered: function(btn, toolbarRenderer) {
            $(btn).addClass('disabled');
        },
    },
    // go back to the read only page
    {
        label: 'Close Record',
        cssClasses: 'btn-success finish-editing',
        groupCssClasses: 'pull-right',
        onRender: function(btn, node, tree, toolbarRenderer) {
            var readonlyPath = location.pathname.replace(/\/edit$/, '');
            btn.attr('href', readonlyPath + location.hash);
        },
        isEnabled: function(node, tree, toolbarRenderer) {
            return true;
        },
        isVisible: function(node, tree, toolbarRenderer) {
            return !tree.large_tree.read_only;
        }
    },
];

var TreeToolbarConfiguration = {
    resource: [].concat(SHARED_TOOLBAR_ACTIONS).concat([
        {
            label: 'Add Child',
            cssClasses: 'btn-default',
            onClick: function(event, btn, node, tree, toolbarRenderer) {
                tree.ajax_tree.add_new_after(node, node.data('level') + 1);
            },
            isEnabled: function(node, tree, toolbarRenderer) {
                return true;
            },
            isVisible: function(node, tree, toolbarRenderer) {
                return !tree.large_tree.read_only;
            },
            onFormLoaded: function(btn, form, tree, toolbarRenderer) {
                $(btn).removeClass('disabled');
            },
            onToolbarRendered: function(btn, toolbarRenderer) {
                $(btn).addClass('disabled');
            },
        }
    ]),

    archival_object: [].concat(SHARED_TOOLBAR_ACTIONS).concat([
        [
            {
                label: 'Add Child',
                cssClasses: 'btn-default',
                onClick: function(event, btn, node, tree, toolbarRenderer) {
                    tree.ajax_tree.add_new_after(node, node.data('level') + 1);
                },
                isEnabled: function(node, tree, toolbarRenderer) {
                    return true;
                },
                isVisible: function(node, tree, toolbarRenderer) {
                    return !tree.large_tree.read_only;
                },
                onFormLoaded: function(btn, form, tree, toolbarRenderer) {
                    $(btn).removeClass('disabled');
                },
                onToolbarRendered: function(btn, toolbarRenderer) {
                    $(btn).addClass('disabled');
                },
            },
            {
                label: 'Add Sibling',
                cssClasses: 'btn-default',
                onClick: function(event, btn, node, tree, toolbarRenderer) {
                    tree.ajax_tree.add_new_after(node, node.data('level'));
                },
                isEnabled: function(node, tree, toolbarRenderer) {
                    return true;
                },
                isVisible: function(node, tree, toolbarRenderer) {
                    return !tree.large_tree.read_only;
                },
                onFormLoaded: function(btn, form, tree, toolbarRenderer) {
                    $(btn).removeClass('disabled');
                },
                onToolbarRendered: function(btn, toolbarRenderer) {
                    $(btn).addClass('disabled');
                },
            }
        ],
        {
            label: 'Transfer',
            cssClasses: 'btn-default dropdown-toggle transfer-node',
            groupCssClasses: 'dropdown',
            onRender: function(btn, node, tree, toolbarRenderer) {
                var $li = btn.parent();
                btn.replaceWith(AS.renderTemplate('tree_toolbar_transfer_action', {
                                    node_id: TreeIds.uri_to_parts(node.data('uri')).id,
                                    root_object_id: TreeIds.uri_to_parts(tree.large_tree.root_uri).id,
                                }));
                $(".linker:not(.initialised)", $li).linker()

                var $form = $li.find('form');
                $form.on('submit', function(event) {
                    if ($(this).serializeObject()['transfer[ref]']) {
                        // continue with the POST
                        return;
                    } else {
                        event.stopPropagation();
                        event.preventDefault();
                        $(".missing-ref-message", $form).show();
                        return true;
                    }
                }).on('click', '.btn-cancel', function(event) {
                    event.preventDefault();
                    event.stopPropagation();
                    $(this).closest('.btn-group.dropdown').toggleClass("open");
                }).on('click', ':input', function(event) {
                    event.stopPropagation();
                }).on("click", ".dropdown-toggle", function(event) {
                    event.stopPropagation();
                    $(this).parent().toggleClass("open");
                });
                $li.on('shown.bs.dropdown', function() {
                    $("#token-input-transfer_ref_", $form).focus();
                });
            },
            isVisible: function(node, tree, toolbarRenderer) {
                return !tree.large_tree.read_only;
            },
        }
    ]),

    digital_object: [].concat(SHARED_TOOLBAR_ACTIONS).concat([
        {
            label: 'Add Child',
            cssClasses: 'btn-default',
            onClick: function(event, btn, node, tree, toolbarRenderer) {
                tree.ajax_tree.add_new_after(node, node.data('level') + 1);
            },
            isEnabled: function(node, tree, toolbarRenderer) {
                return true;
            },
            isVisible: function(node, tree, toolbarRenderer) {
                return !tree.large_tree.read_only;
            },
            onFormLoaded: function(btn, form, tree, toolbarRenderer) {
                $(btn).removeClass('disabled');
            },
            onToolbarRendered: function(btn, toolbarRenderer) {
                $(btn).addClass('disabled');
            },
        }
    ]),

    digital_object_component: [].concat(SHARED_TOOLBAR_ACTIONS).concat([
        [
            {
                label: 'Add Child',
                cssClasses: 'btn-default',
                onClick: function(event, btn, node, tree, toolbarRenderer) {
                    tree.ajax_tree.add_new_after(node, node.data('level') + 1);
                },
                isEnabled: function(node, tree, toolbarRenderer) {
                    return true;
                },
                isVisible: function(node, tree, toolbarRenderer) {
                    return !tree.large_tree.read_only;
                },
                onFormLoaded: function(btn, form, tree, toolbarRenderer) {
                    $(btn).removeClass('disabled');
                },
                onToolbarRendered: function(btn, toolbarRenderer) {
                    $(btn).addClass('disabled');
                },
            },
            {
                label: 'Add Sibling',
                cssClasses: 'btn-default',
                onClick: function(event, btn, node, tree, toolbarRenderer) {
                    tree.ajax_tree.add_new_after(node, node.data('level'));
                },
                isEnabled: function(node, tree, toolbarRenderer) {
                    return true;
                },
                isVisible: function(node, tree, toolbarRenderer) {
                    return !tree.large_tree.read_only;
                },
                onFormLoaded: function(btn, form, tree, toolbarRenderer) {
                    $(btn).removeClass('disabled');
                },
                onToolbarRendered: function(btn, toolbarRenderer) {
                    $(btn).addClass('disabled');
                },
            }
        ]
    ]),

    classification: [].concat(SHARED_TOOLBAR_ACTIONS).concat([
        {
            label: 'Add Child',
            cssClasses: 'btn-default',
            onClick: function(event, btn, node, tree, toolbarRenderer) {
                tree.ajax_tree.add_new_after(node, node.data('level') + 1);
            },
            isEnabled: function(node, tree, toolbarRenderer) {
                return true;
            },
            isVisible: function(node, tree, toolbarRenderer) {
                return !tree.large_tree.read_only;
            },
            onFormLoaded: function(btn, form, tree, toolbarRenderer) {
                $(btn).removeClass('disabled');
            },
            onToolbarRendered: function(btn, toolbarRenderer) {
                $(btn).addClass('disabled');
            },
        }
    ]),

    classification_term: [].concat(SHARED_TOOLBAR_ACTIONS).concat([
        [
            {
                label: 'Add Child',
                cssClasses: 'btn-default',
                onClick: function(event, btn, node, tree, toolbarRenderer) {
                    tree.ajax_tree.add_new_after(node, node.data('level') + 1);
                },
                isEnabled: function(node, tree, toolbarRenderer) {
                    return true;
                },
                isVisible: function(node, tree, toolbarRenderer) {
                    return !tree.large_tree.read_only;
                },
                onFormLoaded: function(btn, form, tree, toolbarRenderer) {
                    $(btn).removeClass('disabled');
                },
                onToolbarRendered: function(btn, toolbarRenderer) {
                    $(btn).addClass('disabled');
                },
            },
            {
                label: 'Add Sibling',
                cssClasses: 'btn-default',
                onClick: function(event, btn, node, tree, toolbarRenderer) {
                    tree.ajax_tree.add_new_after(node, node.data('level'));
                },
                isEnabled: function(node, tree, toolbarRenderer) {
                    return true;
                },
                isVisible: function(node, tree, toolbarRenderer) {
                    return !tree.large_tree.read_only;
                },
                onFormLoaded: function(btn, form, tree, toolbarRenderer) {
                    $(btn).removeClass('disabled');
                },
                onToolbarRendered: function(btn, toolbarRenderer) {
                    $(btn).addClass('disabled');
                },
            },
        ]
    ]),
};

function TreeToolbarRenderer(tree, container) {
    this.tree = tree;
    this.container = container;
}

TreeToolbarRenderer.prototype.reset = function() {
    if (this.current_node) {
        this.render(this.current_node);
    }
};

TreeToolbarRenderer.prototype.reset_callbacks = function() {
    this.on_form_changed_callbacks = [];
    this.on_form_loaded_callbacks = [];
    this.on_toolbar_rendered_callbacks = [];
};

TreeToolbarRenderer.prototype.render = function(node) {
    var self = this;

    if (self.current_node) {
        self.reset_callbacks();
    }

    self.current_node = node;

    var actions = TreeToolbarConfiguration[node.data('jsonmodel_type')];
    self.container.empty();

    if (actions == null) {
        return
    }

    self.reset_callbacks();

    actions.map(function(action_or_group) {
        if (!$.isArray(action_or_group)) {
            action_group = [action_or_group];
        } else {
            action_group = action_or_group;
        }
        var $group = $('<div>').addClass('btn-group');
        self.container.append($group);

        action_group.map(function(action) {
            if (action.isVisible == undefined || $.proxy(action.isVisible, tree)(node, tree, self)) {
                var $btn = $('<a>').addClass('btn btn-xs');
                $btn.html(action.label).addClass(action.cssClasses).attr('href', 'javascript:void(0)');

                if (action.isEnabled == undefined || $.proxy(action.isEnabled, tree)(node, tree, self)) {
                    if (action.onClick) {
                        $btn.on('click', function (event) {
                            return $.proxy(action.onClick, tree)(event, $btn, node, tree, self);
                        });
                    }
                } else {
                    $btn.addClass('disabled');
                }

                if (action.groupCssClasses) {
                    $group.addClass(action.groupCssClasses);
                }

                if (action.onFormChanged) {
                    self.on_form_changed_callbacks.push(function(form) {
                        $.proxy(action.onFormChanged, tree)($btn, form, tree, self);
                    });
                }

                if (action.onFormLoaded) {
                    self.on_form_loaded_callbacks.push(function(form) {
                        $.proxy(action.onFormLoaded, tree)($btn, form, tree, self);
                    });
                }

                if (action.onToolbarRendered) {
                    self.on_toolbar_rendered_callbacks.push(function() {
                        $.proxy(action.onToolbarRendered, tree)($btn, self);
                    });
                }

                $group.append($btn);

                if (action.onRender) {
                    $.proxy(action.onRender, tree)($btn, node, tree, self);
                }
            }
        });

        if ($group.length == 0) {
            $group.remove();
        }
    });

    $.each(self.on_toolbar_rendered_callbacks, function(i, callback) {
        callback();
    });
};

TreeToolbarRenderer.prototype.notify_form_changed = function(form) {
    $.each(this.on_form_changed_callbacks, function(i, callback) {
        callback(form);
    });
};

TreeToolbarRenderer.prototype.notify_form_loaded = function(form) {
    $.each(this.on_form_loaded_callbacks, function(i, callback) {
        callback(form);
    });
};
