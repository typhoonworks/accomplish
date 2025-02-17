"use strict";
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

// js/server.js
var server_exports2 = {};
__export(server_exports2, {
  render: () => render2
});
module.exports = __toCommonJS(server_exports2);

// import-glob:../svelte/**/*.svelte
var __exports = {};
__export(__exports, {
  default: () => __default,
  filenames: () => filenames
});

// svelte/Example.svelte
var Example_exports = {};
__export(Example_exports, {
  default: () => Example_default
});

// node_modules/svelte/src/constants.js
var EACH_INDEX_REACTIVE = 1 << 1;
var EACH_IS_CONTROLLED = 1 << 2;
var EACH_IS_ANIMATED = 1 << 3;
var EACH_ITEM_IMMUTABLE = 1 << 4;
var PROPS_IS_RUNES = 1 << 1;
var PROPS_IS_UPDATED = 1 << 2;
var PROPS_IS_BINDABLE = 1 << 3;
var PROPS_IS_LAZY_INITIAL = 1 << 4;
var TRANSITION_OUT = 1 << 1;
var TRANSITION_GLOBAL = 1 << 2;
var TEMPLATE_USE_IMPORT_NODE = 1 << 1;
var HYDRATION_START = "[";
var HYDRATION_START_ELSE = "[!";
var HYDRATION_END = "]";
var HYDRATION_ERROR = {};
var ELEMENT_PRESERVE_ATTRIBUTE_CASE = 1 << 1;
var UNINITIALIZED = Symbol();
var FILENAME = Symbol("filename");
var HMR = Symbol("hmr");

// node_modules/svelte/src/escaping.js
var ATTR_REGEX = /[&"<]/g;
var CONTENT_REGEX = /[&<]/g;
function escape_html(value, is_attr) {
  const str = String(value ?? "");
  const pattern = is_attr ? ATTR_REGEX : CONTENT_REGEX;
  pattern.lastIndex = 0;
  let escaped = "";
  let last = 0;
  while (pattern.test(str)) {
    const i = pattern.lastIndex - 1;
    const ch = str[i];
    escaped += str.substring(last, i) + (ch === "&" ? "&amp;" : ch === '"' ? "&quot;" : "&lt;");
    last = i + 1;
  }
  return escaped + str.substring(last);
}

// node_modules/svelte/src/internal/shared/utils.js
var is_array = Array.isArray;
var index_of = Array.prototype.indexOf;
var array_from = Array.from;
var object_keys = Object.keys;
var define_property = Object.defineProperty;
var get_descriptor = Object.getOwnPropertyDescriptor;
var object_prototype = Object.prototype;
var array_prototype = Array.prototype;
function run_all(arr) {
  for (var i = 0; i < arr.length; i++) {
    arr[i]();
  }
}
function fallback(value, fallback2, lazy = false) {
  return value === void 0 ? lazy ? (
    /** @type {() => V} */
    fallback2()
  ) : (
    /** @type {V} */
    fallback2
  ) : value;
}

// node_modules/esm-env/true.js
var true_default = true;

// node_modules/svelte/src/internal/client/constants.js
var DERIVED = 1 << 1;
var EFFECT = 1 << 2;
var RENDER_EFFECT = 1 << 3;
var BLOCK_EFFECT = 1 << 4;
var BRANCH_EFFECT = 1 << 5;
var ROOT_EFFECT = 1 << 6;
var BOUNDARY_EFFECT = 1 << 7;
var UNOWNED = 1 << 8;
var DISCONNECTED = 1 << 9;
var CLEAN = 1 << 10;
var DIRTY = 1 << 11;
var MAYBE_DIRTY = 1 << 12;
var INERT = 1 << 13;
var DESTROYED = 1 << 14;
var EFFECT_RAN = 1 << 15;
var EFFECT_TRANSPARENT = 1 << 16;
var LEGACY_DERIVED_PROP = 1 << 17;
var INSPECT_EFFECT = 1 << 18;
var HEAD_EFFECT = 1 << 19;
var EFFECT_HAS_DERIVED = 1 << 20;
var STATE_SYMBOL = Symbol("$state");
var STATE_SYMBOL_METADATA = Symbol("$state metadata");
var LEGACY_PROPS = Symbol("legacy props");
var LOADING_ATTR_SYMBOL = Symbol("");

// node_modules/svelte/src/internal/client/reactivity/equality.js
function equals(value) {
  return value === this.v;
}
function safe_not_equal(a, b) {
  return a != a ? b == b : a !== b || a !== null && typeof a === "object" || typeof a === "function";
}
function safe_equals(value) {
  return !safe_not_equal(value, this.v);
}

// node_modules/svelte/src/internal/client/errors.js
function derived_references_self() {
  if (true_default) {
    const error = new Error(`derived_references_self
A derived value cannot reference itself recursively
https://svelte.dev/e/derived_references_self`);
    error.name = "Svelte error";
    throw error;
  } else {
    throw new Error(`https://svelte.dev/e/derived_references_self`);
  }
}
function effect_update_depth_exceeded() {
  if (true_default) {
    const error = new Error(`effect_update_depth_exceeded
Maximum update depth exceeded. This can happen when a reactive block or effect repeatedly sets a new value. Svelte limits the number of nested updates to prevent infinite loops
https://svelte.dev/e/effect_update_depth_exceeded`);
    error.name = "Svelte error";
    throw error;
  } else {
    throw new Error(`https://svelte.dev/e/effect_update_depth_exceeded`);
  }
}
function hydration_failed() {
  if (true_default) {
    const error = new Error(`hydration_failed
Failed to hydrate the application
https://svelte.dev/e/hydration_failed`);
    error.name = "Svelte error";
    throw error;
  } else {
    throw new Error(`https://svelte.dev/e/hydration_failed`);
  }
}
function rune_outside_svelte(rune) {
  if (true_default) {
    const error = new Error(`rune_outside_svelte
The \`${rune}\` rune is only available inside \`.svelte\` and \`.svelte.js/ts\` files
https://svelte.dev/e/rune_outside_svelte`);
    error.name = "Svelte error";
    throw error;
  } else {
    throw new Error(`https://svelte.dev/e/rune_outside_svelte`);
  }
}
function state_unsafe_local_read() {
  if (true_default) {
    const error = new Error(`state_unsafe_local_read
Reading state that was created inside the same derived is forbidden. Consider using \`untrack\` to read locally created state
https://svelte.dev/e/state_unsafe_local_read`);
    error.name = "Svelte error";
    throw error;
  } else {
    throw new Error(`https://svelte.dev/e/state_unsafe_local_read`);
  }
}
function state_unsafe_mutation() {
  if (true_default) {
    const error = new Error(`state_unsafe_mutation
Updating state inside a derived or a template expression is forbidden. If the value should not be reactive, declare it without \`$state\`
https://svelte.dev/e/state_unsafe_mutation`);
    error.name = "Svelte error";
    throw error;
  } else {
    throw new Error(`https://svelte.dev/e/state_unsafe_mutation`);
  }
}

// node_modules/svelte/src/internal/flags/index.js
var legacy_mode_flag = false;
var tracing_mode_flag = false;

// node_modules/svelte/src/internal/client/dev/tracing.js
var tracing_expressions = null;
function get_stack(label) {
  let error = Error();
  const stack2 = error.stack;
  if (stack2) {
    const lines = stack2.split("\n");
    const new_lines = ["\n"];
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      if (line === "Error") {
        continue;
      }
      if (line.includes("validate_each_keys")) {
        return null;
      }
      if (line.includes("svelte/src/internal")) {
        continue;
      }
      new_lines.push(line);
    }
    if (new_lines.length === 1) {
      return null;
    }
    define_property(error, "stack", {
      value: new_lines.join("\n")
    });
    define_property(error, "name", {
      // 'Error' suffix is required for stack traces to be rendered properly
      value: `${label}Error`
    });
  }
  return error;
}

// node_modules/svelte/src/internal/client/warnings.js
var bold = "font-weight: bold";
var normal = "font-weight: normal";
function hydration_mismatch(location) {
  if (true_default) {
    console.warn(`%c[svelte] hydration_mismatch
%c${location ? `Hydration failed because the initial UI does not match what was rendered on the server. The error occurred near ${location}` : "Hydration failed because the initial UI does not match what was rendered on the server"}
https://svelte.dev/e/hydration_mismatch`, bold, normal);
  } else {
    console.warn(`https://svelte.dev/e/hydration_mismatch`);
  }
}
function lifecycle_double_unmount() {
  if (true_default) {
    console.warn(`%c[svelte] lifecycle_double_unmount
%cTried to unmount a component that was not mounted
https://svelte.dev/e/lifecycle_double_unmount`, bold, normal);
  } else {
    console.warn(`https://svelte.dev/e/lifecycle_double_unmount`);
  }
}
function state_proxy_equality_mismatch(operator) {
  if (true_default) {
    console.warn(`%c[svelte] state_proxy_equality_mismatch
%cReactive \`$state(...)\` proxies and the values they proxy have different identities. Because of this, comparisons with \`${operator}\` will produce unexpected results
https://svelte.dev/e/state_proxy_equality_mismatch`, bold, normal);
  } else {
    console.warn(`https://svelte.dev/e/state_proxy_equality_mismatch`);
  }
}

// node_modules/svelte/src/internal/client/dev/ownership.js
var ADD_OWNER = Symbol("ADD_OWNER");

// node_modules/svelte/src/internal/client/context.js
var component_context = null;
function set_component_context(context) {
  component_context = context;
}
var dev_current_component_function = null;
function set_dev_current_component_function(fn) {
  dev_current_component_function = fn;
}
function push(props, runes = false, fn) {
  component_context = {
    p: component_context,
    c: null,
    e: null,
    m: false,
    s: props,
    x: null,
    l: null
  };
  if (legacy_mode_flag && !runes) {
    component_context.l = {
      s: null,
      u: null,
      r1: [],
      r2: source(false)
    };
  }
  if (true_default) {
    component_context.function = fn;
    dev_current_component_function = fn;
  }
}
function pop(component2) {
  const context_stack_item = component_context;
  if (context_stack_item !== null) {
    if (component2 !== void 0) {
      context_stack_item.x = component2;
    }
    const component_effects = context_stack_item.e;
    if (component_effects !== null) {
      var previous_effect = active_effect;
      var previous_reaction = active_reaction;
      context_stack_item.e = null;
      try {
        for (var i = 0; i < component_effects.length; i++) {
          var component_effect = component_effects[i];
          set_active_effect(component_effect.effect);
          set_active_reaction(component_effect.reaction);
          effect(component_effect.fn);
        }
      } finally {
        set_active_effect(previous_effect);
        set_active_reaction(previous_reaction);
      }
    }
    component_context = context_stack_item.p;
    if (true_default) {
      dev_current_component_function = context_stack_item.p?.function ?? null;
    }
    context_stack_item.m = true;
  }
  return component2 || /** @type {T} */
  {};
}
function is_runes() {
  return !legacy_mode_flag || component_context !== null && component_context.l === null;
}

// node_modules/svelte/src/internal/client/reactivity/sources.js
var inspect_effects = /* @__PURE__ */ new Set();
function set_inspect_effects(v) {
  inspect_effects = v;
}
function source(v, stack2) {
  var signal = {
    f: 0,
    // TODO ideally we could skip this altogether, but it causes type errors
    v,
    reactions: null,
    equals,
    rv: 0,
    wv: 0
  };
  if (true_default && tracing_mode_flag) {
    signal.created = stack2 ?? get_stack("CreatedAt");
    signal.debug = null;
  }
  return signal;
}
// @__NO_SIDE_EFFECTS__
function mutable_source(initial_value, immutable = false) {
  const s = source(initial_value);
  if (!immutable) {
    s.equals = safe_equals;
  }
  if (legacy_mode_flag && component_context !== null && component_context.l !== null) {
    (component_context.l.s ??= []).push(s);
  }
  return s;
}
function set(source2, value) {
  if (active_reaction !== null && !untracking && is_runes() && (active_reaction.f & (DERIVED | BLOCK_EFFECT)) !== 0 && // If the source was created locally within the current derived, then
  // we allow the mutation.
  (derived_sources === null || !derived_sources.includes(source2))) {
    state_unsafe_mutation();
  }
  return internal_set(source2, value);
}
function internal_set(source2, value) {
  if (!source2.equals(value)) {
    var old_value = source2.v;
    source2.v = value;
    source2.wv = increment_write_version();
    if (true_default && tracing_mode_flag) {
      source2.updated = get_stack("UpdatedAt");
      if (active_effect != null) {
        source2.trace_need_increase = true;
        source2.trace_v ??= old_value;
      }
    }
    mark_reactions(source2, DIRTY);
    if (is_runes() && active_effect !== null && (active_effect.f & CLEAN) !== 0 && (active_effect.f & (BRANCH_EFFECT | ROOT_EFFECT)) === 0) {
      if (untracked_writes === null) {
        set_untracked_writes([source2]);
      } else {
        untracked_writes.push(source2);
      }
    }
    if (true_default && inspect_effects.size > 0) {
      const inspects = Array.from(inspect_effects);
      var previously_flushing_effect = is_flushing_effect;
      set_is_flushing_effect(true);
      try {
        for (const effect2 of inspects) {
          if ((effect2.f & CLEAN) !== 0) {
            set_signal_status(effect2, MAYBE_DIRTY);
          }
          if (check_dirtiness(effect2)) {
            update_effect(effect2);
          }
        }
      } finally {
        set_is_flushing_effect(previously_flushing_effect);
      }
      inspect_effects.clear();
    }
  }
  return value;
}
function mark_reactions(signal, status) {
  var reactions = signal.reactions;
  if (reactions === null) return;
  var runes = is_runes();
  var length = reactions.length;
  for (var i = 0; i < length; i++) {
    var reaction = reactions[i];
    var flags = reaction.f;
    if ((flags & DIRTY) !== 0) continue;
    if (!runes && reaction === active_effect) continue;
    if (true_default && (flags & INSPECT_EFFECT) !== 0) {
      inspect_effects.add(reaction);
      continue;
    }
    set_signal_status(reaction, status);
    if ((flags & (CLEAN | UNOWNED)) !== 0) {
      if ((flags & DERIVED) !== 0) {
        mark_reactions(
          /** @type {Derived} */
          reaction,
          MAYBE_DIRTY
        );
      } else {
        schedule_effect(
          /** @type {Effect} */
          reaction
        );
      }
    }
  }
}

// node_modules/svelte/src/internal/client/dom/hydration.js
var hydrating = false;
function set_hydrating(value) {
  hydrating = value;
}
var hydrate_node;
function set_hydrate_node(node) {
  if (node === null) {
    hydration_mismatch();
    throw HYDRATION_ERROR;
  }
  return hydrate_node = node;
}
function hydrate_next() {
  return set_hydrate_node(
    /** @type {TemplateNode} */
    get_next_sibling(hydrate_node)
  );
}

// node_modules/svelte/src/internal/client/proxy.js
function get_proxied_value(value) {
  if (value !== null && typeof value === "object" && STATE_SYMBOL in value) {
    return value[STATE_SYMBOL];
  }
  return value;
}

// node_modules/svelte/src/internal/client/dev/equality.js
function init_array_prototype_warnings() {
  const array_prototype2 = Array.prototype;
  const cleanup = Array.__svelte_cleanup;
  if (cleanup) {
    cleanup();
  }
  const { indexOf, lastIndexOf, includes } = array_prototype2;
  array_prototype2.indexOf = function(item, from_index) {
    const index2 = indexOf.call(this, item, from_index);
    if (index2 === -1) {
      for (let i = from_index ?? 0; i < this.length; i += 1) {
        if (get_proxied_value(this[i]) === item) {
          state_proxy_equality_mismatch("array.indexOf(...)");
          break;
        }
      }
    }
    return index2;
  };
  array_prototype2.lastIndexOf = function(item, from_index) {
    const index2 = lastIndexOf.call(this, item, from_index ?? this.length - 1);
    if (index2 === -1) {
      for (let i = 0; i <= (from_index ?? this.length - 1); i += 1) {
        if (get_proxied_value(this[i]) === item) {
          state_proxy_equality_mismatch("array.lastIndexOf(...)");
          break;
        }
      }
    }
    return index2;
  };
  array_prototype2.includes = function(item, from_index) {
    const has = includes.call(this, item, from_index);
    if (!has) {
      for (let i = 0; i < this.length; i += 1) {
        if (get_proxied_value(this[i]) === item) {
          state_proxy_equality_mismatch("array.includes(...)");
          break;
        }
      }
    }
    return has;
  };
  Array.__svelte_cleanup = () => {
    array_prototype2.indexOf = indexOf;
    array_prototype2.lastIndexOf = lastIndexOf;
    array_prototype2.includes = includes;
  };
}

// node_modules/svelte/src/internal/client/dom/operations.js
var $window;
var $document;
var is_firefox;
var first_child_getter;
var next_sibling_getter;
function init_operations() {
  if ($window !== void 0) {
    return;
  }
  $window = window;
  $document = document;
  is_firefox = /Firefox/.test(navigator.userAgent);
  var element_prototype = Element.prototype;
  var node_prototype = Node.prototype;
  first_child_getter = get_descriptor(node_prototype, "firstChild").get;
  next_sibling_getter = get_descriptor(node_prototype, "nextSibling").get;
  element_prototype.__click = void 0;
  element_prototype.__className = "";
  element_prototype.__attributes = null;
  element_prototype.__styles = null;
  element_prototype.__e = void 0;
  Text.prototype.__t = void 0;
  if (true_default) {
    element_prototype.__svelte_meta = null;
    init_array_prototype_warnings();
  }
}
function create_text(value = "") {
  return document.createTextNode(value);
}
// @__NO_SIDE_EFFECTS__
function get_first_child(node) {
  return first_child_getter.call(node);
}
// @__NO_SIDE_EFFECTS__
function get_next_sibling(node) {
  return next_sibling_getter.call(node);
}
function clear_text_content(node) {
  node.textContent = "";
}

// node_modules/svelte/src/internal/client/reactivity/deriveds.js
function destroy_derived_effects(derived2) {
  var effects = derived2.effects;
  if (effects !== null) {
    derived2.effects = null;
    for (var i = 0; i < effects.length; i += 1) {
      destroy_effect(
        /** @type {Effect} */
        effects[i]
      );
    }
  }
}
var stack = [];
function get_derived_parent_effect(derived2) {
  var parent2 = derived2.parent;
  while (parent2 !== null) {
    if ((parent2.f & DERIVED) === 0) {
      return (
        /** @type {Effect} */
        parent2
      );
    }
    parent2 = parent2.parent;
  }
  return null;
}
function execute_derived(derived2) {
  var value;
  var prev_active_effect = active_effect;
  set_active_effect(get_derived_parent_effect(derived2));
  if (true_default) {
    let prev_inspect_effects = inspect_effects;
    set_inspect_effects(/* @__PURE__ */ new Set());
    try {
      if (stack.includes(derived2)) {
        derived_references_self();
      }
      stack.push(derived2);
      destroy_derived_effects(derived2);
      value = update_reaction(derived2);
    } finally {
      set_active_effect(prev_active_effect);
      set_inspect_effects(prev_inspect_effects);
      stack.pop();
    }
  } else {
    try {
      destroy_derived_effects(derived2);
      value = update_reaction(derived2);
    } finally {
      set_active_effect(prev_active_effect);
    }
  }
  return value;
}
function update_derived(derived2) {
  var value = execute_derived(derived2);
  var status = (skip_reaction || (derived2.f & UNOWNED) !== 0) && derived2.deps !== null ? MAYBE_DIRTY : CLEAN;
  set_signal_status(derived2, status);
  if (!derived2.equals(value)) {
    derived2.v = value;
    derived2.wv = increment_write_version();
  }
}

// node_modules/svelte/src/internal/client/reactivity/effects.js
function push_effect(effect2, parent_effect) {
  var parent_last = parent_effect.last;
  if (parent_last === null) {
    parent_effect.last = parent_effect.first = effect2;
  } else {
    parent_last.next = effect2;
    effect2.prev = parent_last;
    parent_effect.last = effect2;
  }
}
function create_effect(type, fn, sync, push3 = true) {
  var is_root = (type & ROOT_EFFECT) !== 0;
  var parent_effect = active_effect;
  if (true_default) {
    while (parent_effect !== null && (parent_effect.f & INSPECT_EFFECT) !== 0) {
      parent_effect = parent_effect.parent;
    }
  }
  var effect2 = {
    ctx: component_context,
    deps: null,
    nodes_start: null,
    nodes_end: null,
    f: type | DIRTY,
    first: null,
    fn,
    last: null,
    next: null,
    parent: is_root ? null : parent_effect,
    prev: null,
    teardown: null,
    transitions: null,
    wv: 0
  };
  if (true_default) {
    effect2.component_function = dev_current_component_function;
  }
  if (sync) {
    var previously_flushing_effect = is_flushing_effect;
    try {
      set_is_flushing_effect(true);
      update_effect(effect2);
      effect2.f |= EFFECT_RAN;
    } catch (e) {
      destroy_effect(effect2);
      throw e;
    } finally {
      set_is_flushing_effect(previously_flushing_effect);
    }
  } else if (fn !== null) {
    schedule_effect(effect2);
  }
  var inert = sync && effect2.deps === null && effect2.first === null && effect2.nodes_start === null && effect2.teardown === null && (effect2.f & (EFFECT_HAS_DERIVED | BOUNDARY_EFFECT)) === 0;
  if (!inert && !is_root && push3) {
    if (parent_effect !== null) {
      push_effect(effect2, parent_effect);
    }
    if (active_reaction !== null && (active_reaction.f & DERIVED) !== 0) {
      var derived2 = (
        /** @type {Derived} */
        active_reaction
      );
      (derived2.effects ??= []).push(effect2);
    }
  }
  return effect2;
}
function effect_root(fn) {
  const effect2 = create_effect(ROOT_EFFECT, fn, true);
  return () => {
    destroy_effect(effect2);
  };
}
function component_root(fn) {
  const effect2 = create_effect(ROOT_EFFECT, fn, true);
  return (options = {}) => {
    return new Promise((fulfil) => {
      if (options.outro) {
        pause_effect(effect2, () => {
          destroy_effect(effect2);
          fulfil(void 0);
        });
      } else {
        destroy_effect(effect2);
        fulfil(void 0);
      }
    });
  };
}
function effect(fn) {
  return create_effect(EFFECT, fn, false);
}
function render_effect(fn) {
  return create_effect(RENDER_EFFECT, fn, true);
}
function branch(fn, push3 = true) {
  return create_effect(RENDER_EFFECT | BRANCH_EFFECT, fn, true, push3);
}
function execute_effect_teardown(effect2) {
  var teardown2 = effect2.teardown;
  if (teardown2 !== null) {
    const previously_destroying_effect = is_destroying_effect;
    const previous_reaction = active_reaction;
    set_is_destroying_effect(true);
    set_active_reaction(null);
    try {
      teardown2.call(null);
    } finally {
      set_is_destroying_effect(previously_destroying_effect);
      set_active_reaction(previous_reaction);
    }
  }
}
function destroy_effect_children(signal, remove_dom = false) {
  var effect2 = signal.first;
  signal.first = signal.last = null;
  while (effect2 !== null) {
    var next2 = effect2.next;
    destroy_effect(effect2, remove_dom);
    effect2 = next2;
  }
}
function destroy_block_effect_children(signal) {
  var effect2 = signal.first;
  while (effect2 !== null) {
    var next2 = effect2.next;
    if ((effect2.f & BRANCH_EFFECT) === 0) {
      destroy_effect(effect2);
    }
    effect2 = next2;
  }
}
function destroy_effect(effect2, remove_dom = true) {
  var removed = false;
  if ((remove_dom || (effect2.f & HEAD_EFFECT) !== 0) && effect2.nodes_start !== null) {
    var node = effect2.nodes_start;
    var end = effect2.nodes_end;
    while (node !== null) {
      var next2 = node === end ? null : (
        /** @type {TemplateNode} */
        get_next_sibling(node)
      );
      node.remove();
      node = next2;
    }
    removed = true;
  }
  destroy_effect_children(effect2, remove_dom && !removed);
  remove_reactions(effect2, 0);
  set_signal_status(effect2, DESTROYED);
  var transitions = effect2.transitions;
  if (transitions !== null) {
    for (const transition2 of transitions) {
      transition2.stop();
    }
  }
  execute_effect_teardown(effect2);
  var parent2 = effect2.parent;
  if (parent2 !== null && parent2.first !== null) {
    unlink_effect(effect2);
  }
  if (true_default) {
    effect2.component_function = null;
  }
  effect2.next = effect2.prev = effect2.teardown = effect2.ctx = effect2.deps = effect2.fn = effect2.nodes_start = effect2.nodes_end = null;
}
function unlink_effect(effect2) {
  var parent2 = effect2.parent;
  var prev = effect2.prev;
  var next2 = effect2.next;
  if (prev !== null) prev.next = next2;
  if (next2 !== null) next2.prev = prev;
  if (parent2 !== null) {
    if (parent2.first === effect2) parent2.first = next2;
    if (parent2.last === effect2) parent2.last = prev;
  }
}
function pause_effect(effect2, callback) {
  var transitions = [];
  pause_children(effect2, transitions, true);
  run_out_transitions(transitions, () => {
    destroy_effect(effect2);
    if (callback) callback();
  });
}
function run_out_transitions(transitions, fn) {
  var remaining = transitions.length;
  if (remaining > 0) {
    var check = () => --remaining || fn();
    for (var transition2 of transitions) {
      transition2.out(check);
    }
  } else {
    fn();
  }
}
function pause_children(effect2, transitions, local) {
  if ((effect2.f & INERT) !== 0) return;
  effect2.f ^= INERT;
  if (effect2.transitions !== null) {
    for (const transition2 of effect2.transitions) {
      if (transition2.is_global || local) {
        transitions.push(transition2);
      }
    }
  }
  var child2 = effect2.first;
  while (child2 !== null) {
    var sibling2 = child2.next;
    var transparent = (child2.f & EFFECT_TRANSPARENT) !== 0 || (child2.f & BRANCH_EFFECT) !== 0;
    pause_children(child2, transitions, transparent ? local : false);
    child2 = sibling2;
  }
}

// node_modules/svelte/src/internal/client/dom/task.js
var is_micro_task_queued = false;
var is_idle_task_queued = false;
var current_queued_micro_tasks = [];
var current_queued_idle_tasks = [];
function process_micro_tasks() {
  is_micro_task_queued = false;
  const tasks = current_queued_micro_tasks.slice();
  current_queued_micro_tasks = [];
  run_all(tasks);
}
function process_idle_tasks() {
  is_idle_task_queued = false;
  const tasks = current_queued_idle_tasks.slice();
  current_queued_idle_tasks = [];
  run_all(tasks);
}
function flush_tasks() {
  if (is_micro_task_queued) {
    process_micro_tasks();
  }
  if (is_idle_task_queued) {
    process_idle_tasks();
  }
}

// node_modules/svelte/src/internal/client/runtime.js
var FLUSH_MICROTASK = 0;
var FLUSH_SYNC = 1;
var handled_errors = /* @__PURE__ */ new WeakSet();
var is_throwing_error = false;
var scheduler_mode = FLUSH_MICROTASK;
var is_micro_task_queued2 = false;
var last_scheduled_effect = null;
var is_flushing_effect = false;
var is_destroying_effect = false;
function set_is_flushing_effect(value) {
  is_flushing_effect = value;
}
function set_is_destroying_effect(value) {
  is_destroying_effect = value;
}
var queued_root_effects = [];
var flush_count = 0;
var dev_effect_stack = [];
var active_reaction = null;
var untracking = false;
function set_active_reaction(reaction) {
  active_reaction = reaction;
}
var active_effect = null;
function set_active_effect(effect2) {
  active_effect = effect2;
}
var derived_sources = null;
var new_deps = null;
var skipped_deps = 0;
var untracked_writes = null;
function set_untracked_writes(value) {
  untracked_writes = value;
}
var write_version = 1;
var read_version = 0;
var skip_reaction = false;
var captured_signals = null;
function increment_write_version() {
  return ++write_version;
}
function check_dirtiness(reaction) {
  var flags = reaction.f;
  if ((flags & DIRTY) !== 0) {
    return true;
  }
  if ((flags & MAYBE_DIRTY) !== 0) {
    var dependencies = reaction.deps;
    var is_unowned = (flags & UNOWNED) !== 0;
    if (dependencies !== null) {
      var i;
      var dependency;
      var is_disconnected = (flags & DISCONNECTED) !== 0;
      var is_unowned_connected = is_unowned && active_effect !== null && !skip_reaction;
      var length = dependencies.length;
      if (is_disconnected || is_unowned_connected) {
        var derived2 = (
          /** @type {Derived} */
          reaction
        );
        var parent2 = derived2.parent;
        for (i = 0; i < length; i++) {
          dependency = dependencies[i];
          if (is_disconnected || !dependency?.reactions?.includes(derived2)) {
            (dependency.reactions ??= []).push(derived2);
          }
        }
        if (is_disconnected) {
          derived2.f ^= DISCONNECTED;
        }
        if (is_unowned_connected && parent2 !== null && (parent2.f & UNOWNED) === 0) {
          derived2.f ^= UNOWNED;
        }
      }
      for (i = 0; i < length; i++) {
        dependency = dependencies[i];
        if (check_dirtiness(
          /** @type {Derived} */
          dependency
        )) {
          update_derived(
            /** @type {Derived} */
            dependency
          );
        }
        if (dependency.wv > reaction.wv) {
          return true;
        }
      }
    }
    if (!is_unowned || active_effect !== null && !skip_reaction) {
      set_signal_status(reaction, CLEAN);
    }
  }
  return false;
}
function propagate_error(error, effect2) {
  var current = effect2;
  while (current !== null) {
    if ((current.f & BOUNDARY_EFFECT) !== 0) {
      try {
        current.fn(error);
        return;
      } catch {
        current.f ^= BOUNDARY_EFFECT;
      }
    }
    current = current.parent;
  }
  is_throwing_error = false;
  throw error;
}
function should_rethrow_error(effect2) {
  return (effect2.f & DESTROYED) === 0 && (effect2.parent === null || (effect2.parent.f & BOUNDARY_EFFECT) === 0);
}
function handle_error(error, effect2, previous_effect, component_context2) {
  if (is_throwing_error) {
    if (previous_effect === null) {
      is_throwing_error = false;
    }
    if (should_rethrow_error(effect2)) {
      throw error;
    }
    return;
  }
  if (previous_effect !== null) {
    is_throwing_error = true;
  }
  if (!true_default || component_context2 === null || !(error instanceof Error) || handled_errors.has(error)) {
    propagate_error(error, effect2);
    return;
  }
  handled_errors.add(error);
  const component_stack = [];
  const effect_name = effect2.fn?.name;
  if (effect_name) {
    component_stack.push(effect_name);
  }
  let current_context = component_context2;
  while (current_context !== null) {
    if (true_default) {
      var filename = current_context.function?.[FILENAME];
      if (filename) {
        const file = filename.split("/").pop();
        component_stack.push(file);
      }
    }
    current_context = current_context.p;
  }
  const indent = is_firefox ? "  " : "	";
  define_property(error, "message", {
    value: error.message + `
${component_stack.map((name) => `
${indent}in ${name}`).join("")}
`
  });
  define_property(error, "component_stack", {
    value: component_stack
  });
  const stack2 = error.stack;
  if (stack2) {
    const lines = stack2.split("\n");
    const new_lines = [];
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      if (line.includes("svelte/src/internal")) {
        continue;
      }
      new_lines.push(line);
    }
    define_property(error, "stack", {
      value: new_lines.join("\n")
    });
  }
  propagate_error(error, effect2);
  if (should_rethrow_error(effect2)) {
    throw error;
  }
}
function schedule_possible_effect_self_invalidation(signal, effect2, root = true) {
  var reactions = signal.reactions;
  if (reactions === null) return;
  for (var i = 0; i < reactions.length; i++) {
    var reaction = reactions[i];
    if ((reaction.f & DERIVED) !== 0) {
      schedule_possible_effect_self_invalidation(
        /** @type {Derived} */
        reaction,
        effect2,
        false
      );
    } else if (effect2 === reaction) {
      if (root) {
        set_signal_status(reaction, DIRTY);
      } else if ((reaction.f & CLEAN) !== 0) {
        set_signal_status(reaction, MAYBE_DIRTY);
      }
      schedule_effect(
        /** @type {Effect} */
        reaction
      );
    }
  }
}
function update_reaction(reaction) {
  var previous_deps = new_deps;
  var previous_skipped_deps = skipped_deps;
  var previous_untracked_writes = untracked_writes;
  var previous_reaction = active_reaction;
  var previous_skip_reaction = skip_reaction;
  var prev_derived_sources = derived_sources;
  var previous_component_context = component_context;
  var previous_untracking = untracking;
  var flags = reaction.f;
  new_deps = /** @type {null | Value[]} */
  null;
  skipped_deps = 0;
  untracked_writes = null;
  active_reaction = (flags & (BRANCH_EFFECT | ROOT_EFFECT)) === 0 ? reaction : null;
  skip_reaction = (flags & UNOWNED) !== 0 && (!is_flushing_effect || previous_reaction === null || previous_untracking);
  derived_sources = null;
  set_component_context(reaction.ctx);
  untracking = false;
  read_version++;
  try {
    var result = (
      /** @type {Function} */
      (0, reaction.fn)()
    );
    var deps = reaction.deps;
    if (new_deps !== null) {
      var i;
      remove_reactions(reaction, skipped_deps);
      if (deps !== null && skipped_deps > 0) {
        deps.length = skipped_deps + new_deps.length;
        for (i = 0; i < new_deps.length; i++) {
          deps[skipped_deps + i] = new_deps[i];
        }
      } else {
        reaction.deps = deps = new_deps;
      }
      if (!skip_reaction) {
        for (i = skipped_deps; i < deps.length; i++) {
          (deps[i].reactions ??= []).push(reaction);
        }
      }
    } else if (deps !== null && skipped_deps < deps.length) {
      remove_reactions(reaction, skipped_deps);
      deps.length = skipped_deps;
    }
    if (is_runes() && untracked_writes !== null && !untracking && deps !== null && (reaction.f & (DERIVED | MAYBE_DIRTY | DIRTY)) === 0) {
      for (i = 0; i < /** @type {Source[]} */
      untracked_writes.length; i++) {
        schedule_possible_effect_self_invalidation(
          untracked_writes[i],
          /** @type {Effect} */
          reaction
        );
      }
    }
    if (previous_reaction !== null) {
      read_version++;
    }
    return result;
  } finally {
    new_deps = previous_deps;
    skipped_deps = previous_skipped_deps;
    untracked_writes = previous_untracked_writes;
    active_reaction = previous_reaction;
    skip_reaction = previous_skip_reaction;
    derived_sources = prev_derived_sources;
    set_component_context(previous_component_context);
    untracking = previous_untracking;
  }
}
function remove_reaction(signal, dependency) {
  let reactions = dependency.reactions;
  if (reactions !== null) {
    var index2 = index_of.call(reactions, signal);
    if (index2 !== -1) {
      var new_length = reactions.length - 1;
      if (new_length === 0) {
        reactions = dependency.reactions = null;
      } else {
        reactions[index2] = reactions[new_length];
        reactions.pop();
      }
    }
  }
  if (reactions === null && (dependency.f & DERIVED) !== 0 && // Destroying a child effect while updating a parent effect can cause a dependency to appear
  // to be unused, when in fact it is used by the currently-updating parent. Checking `new_deps`
  // allows us to skip the expensive work of disconnecting and immediately reconnecting it
  (new_deps === null || !new_deps.includes(dependency))) {
    set_signal_status(dependency, MAYBE_DIRTY);
    if ((dependency.f & (UNOWNED | DISCONNECTED)) === 0) {
      dependency.f ^= DISCONNECTED;
    }
    destroy_derived_effects(
      /** @type {Derived} **/
      dependency
    );
    remove_reactions(
      /** @type {Derived} **/
      dependency,
      0
    );
  }
}
function remove_reactions(signal, start_index) {
  var dependencies = signal.deps;
  if (dependencies === null) return;
  for (var i = start_index; i < dependencies.length; i++) {
    remove_reaction(signal, dependencies[i]);
  }
}
function update_effect(effect2) {
  var flags = effect2.f;
  if ((flags & DESTROYED) !== 0) {
    return;
  }
  set_signal_status(effect2, CLEAN);
  var previous_effect = active_effect;
  var previous_component_context = component_context;
  active_effect = effect2;
  if (true_default) {
    var previous_component_fn = dev_current_component_function;
    set_dev_current_component_function(effect2.component_function);
  }
  try {
    if ((flags & BLOCK_EFFECT) !== 0) {
      destroy_block_effect_children(effect2);
    } else {
      destroy_effect_children(effect2);
    }
    execute_effect_teardown(effect2);
    var teardown2 = update_reaction(effect2);
    effect2.teardown = typeof teardown2 === "function" ? teardown2 : null;
    effect2.wv = write_version;
    var deps = effect2.deps;
    if (true_default && tracing_mode_flag && (effect2.f & DIRTY) !== 0 && deps !== null) {
      for (let i = 0; i < deps.length; i++) {
        var dep = deps[i];
        if (dep.trace_need_increase) {
          dep.wv = increment_write_version();
          dep.trace_need_increase = void 0;
          dep.trace_v = void 0;
        }
      }
    }
    if (true_default) {
      dev_effect_stack.push(effect2);
    }
  } catch (error) {
    handle_error(error, effect2, previous_effect, previous_component_context || effect2.ctx);
  } finally {
    active_effect = previous_effect;
    if (true_default) {
      set_dev_current_component_function(previous_component_fn);
    }
  }
}
function log_effect_stack() {
  console.error(
    "Last ten effects were: ",
    dev_effect_stack.slice(-10).map((d) => d.fn)
  );
  dev_effect_stack = [];
}
function infinite_loop_guard() {
  if (flush_count > 1e3) {
    flush_count = 0;
    try {
      effect_update_depth_exceeded();
    } catch (error) {
      if (true_default) {
        define_property(error, "stack", {
          value: ""
        });
      }
      if (last_scheduled_effect !== null) {
        if (true_default) {
          try {
            handle_error(error, last_scheduled_effect, null, null);
          } catch (e) {
            log_effect_stack();
            throw e;
          }
        } else {
          handle_error(error, last_scheduled_effect, null, null);
        }
      } else {
        if (true_default) {
          log_effect_stack();
        }
        throw error;
      }
    }
  }
  flush_count++;
}
function flush_queued_root_effects(root_effects) {
  var length = root_effects.length;
  if (length === 0) {
    return;
  }
  infinite_loop_guard();
  var previously_flushing_effect = is_flushing_effect;
  is_flushing_effect = true;
  try {
    for (var i = 0; i < length; i++) {
      var effect2 = root_effects[i];
      if ((effect2.f & CLEAN) === 0) {
        effect2.f ^= CLEAN;
      }
      var collected_effects = process_effects(effect2);
      flush_queued_effects(collected_effects);
    }
  } finally {
    is_flushing_effect = previously_flushing_effect;
  }
}
function flush_queued_effects(effects) {
  var length = effects.length;
  if (length === 0) return;
  for (var i = 0; i < length; i++) {
    var effect2 = effects[i];
    if ((effect2.f & (DESTROYED | INERT)) === 0) {
      try {
        if (check_dirtiness(effect2)) {
          update_effect(effect2);
          if (effect2.deps === null && effect2.first === null && effect2.nodes_start === null) {
            if (effect2.teardown === null) {
              unlink_effect(effect2);
            } else {
              effect2.fn = null;
            }
          }
        }
      } catch (error) {
        handle_error(error, effect2, null, effect2.ctx);
      }
    }
  }
}
function process_deferred() {
  is_micro_task_queued2 = false;
  if (flush_count > 1001) {
    return;
  }
  const previous_queued_root_effects = queued_root_effects;
  queued_root_effects = [];
  flush_queued_root_effects(previous_queued_root_effects);
  if (!is_micro_task_queued2) {
    flush_count = 0;
    last_scheduled_effect = null;
    if (true_default) {
      dev_effect_stack = [];
    }
  }
}
function schedule_effect(signal) {
  if (scheduler_mode === FLUSH_MICROTASK) {
    if (!is_micro_task_queued2) {
      is_micro_task_queued2 = true;
      queueMicrotask(process_deferred);
    }
  }
  last_scheduled_effect = signal;
  var effect2 = signal;
  while (effect2.parent !== null) {
    effect2 = effect2.parent;
    var flags = effect2.f;
    if ((flags & (ROOT_EFFECT | BRANCH_EFFECT)) !== 0) {
      if ((flags & CLEAN) === 0) return;
      effect2.f ^= CLEAN;
    }
  }
  queued_root_effects.push(effect2);
}
function process_effects(effect2) {
  var effects = [];
  var current_effect = effect2.first;
  main_loop: while (current_effect !== null) {
    var flags = current_effect.f;
    var is_branch = (flags & BRANCH_EFFECT) !== 0;
    var is_skippable_branch = is_branch && (flags & CLEAN) !== 0;
    var sibling2 = current_effect.next;
    if (!is_skippable_branch && (flags & INERT) === 0) {
      if ((flags & EFFECT) !== 0) {
        effects.push(current_effect);
      } else if (is_branch) {
        current_effect.f ^= CLEAN;
      } else {
        var previous_active_reaction = active_reaction;
        try {
          active_reaction = current_effect;
          if (check_dirtiness(current_effect)) {
            update_effect(current_effect);
          }
        } catch (error) {
          handle_error(error, current_effect, null, current_effect.ctx);
        } finally {
          active_reaction = previous_active_reaction;
        }
      }
      var child2 = current_effect.first;
      if (child2 !== null) {
        current_effect = child2;
        continue;
      }
    }
    if (sibling2 === null) {
      let parent2 = current_effect.parent;
      while (parent2 !== null) {
        if (effect2 === parent2) {
          break main_loop;
        }
        var parent_sibling = parent2.next;
        if (parent_sibling !== null) {
          current_effect = parent_sibling;
          continue main_loop;
        }
        parent2 = parent2.parent;
      }
    }
    current_effect = sibling2;
  }
  return effects;
}
function flush_sync(fn) {
  var previous_scheduler_mode = scheduler_mode;
  var previous_queued_root_effects = queued_root_effects;
  try {
    infinite_loop_guard();
    const root_effects = [];
    scheduler_mode = FLUSH_SYNC;
    queued_root_effects = root_effects;
    is_micro_task_queued2 = false;
    flush_queued_root_effects(previous_queued_root_effects);
    var result = fn?.();
    flush_tasks();
    if (queued_root_effects.length > 0 || root_effects.length > 0) {
      flush_sync();
    }
    flush_count = 0;
    last_scheduled_effect = null;
    if (true_default) {
      dev_effect_stack = [];
    }
    return result;
  } finally {
    scheduler_mode = previous_scheduler_mode;
    queued_root_effects = previous_queued_root_effects;
  }
}
function get(signal) {
  var flags = signal.f;
  var is_derived = (flags & DERIVED) !== 0;
  if (captured_signals !== null) {
    captured_signals.add(signal);
  }
  if (active_reaction !== null && !untracking) {
    if (derived_sources !== null && derived_sources.includes(signal)) {
      state_unsafe_local_read();
    }
    var deps = active_reaction.deps;
    if (signal.rv < read_version) {
      signal.rv = read_version;
      if (new_deps === null && deps !== null && deps[skipped_deps] === signal) {
        skipped_deps++;
      } else if (new_deps === null) {
        new_deps = [signal];
      } else if (!skip_reaction || !new_deps.includes(signal)) {
        new_deps.push(signal);
      }
    }
  } else if (is_derived && /** @type {Derived} */
  signal.deps === null && /** @type {Derived} */
  signal.effects === null) {
    var derived2 = (
      /** @type {Derived} */
      signal
    );
    var parent2 = derived2.parent;
    if (parent2 !== null && (parent2.f & UNOWNED) === 0) {
      derived2.f ^= UNOWNED;
    }
  }
  if (is_derived) {
    derived2 = /** @type {Derived} */
    signal;
    if (check_dirtiness(derived2)) {
      update_derived(derived2);
    }
  }
  if (true_default && tracing_mode_flag && tracing_expressions !== null && active_reaction !== null && tracing_expressions.reaction === active_reaction) {
    if (signal.debug) {
      signal.debug();
    } else if (signal.created) {
      var entry = tracing_expressions.entries.get(signal);
      if (entry === void 0) {
        entry = { read: [] };
        tracing_expressions.entries.set(signal, entry);
      }
      entry.read.push(get_stack("TracedAt"));
    }
  }
  return signal.v;
}
var STATUS_MASK = ~(DIRTY | MAYBE_DIRTY | CLEAN);
function set_signal_status(signal, status) {
  signal.f = signal.f & STATUS_MASK | status;
}

// node_modules/svelte/src/utils.js
var DOM_BOOLEAN_ATTRIBUTES = [
  "allowfullscreen",
  "async",
  "autofocus",
  "autoplay",
  "checked",
  "controls",
  "default",
  "disabled",
  "formnovalidate",
  "hidden",
  "indeterminate",
  "inert",
  "ismap",
  "loop",
  "multiple",
  "muted",
  "nomodule",
  "novalidate",
  "open",
  "playsinline",
  "readonly",
  "required",
  "reversed",
  "seamless",
  "selected",
  "webkitdirectory",
  "defer",
  "disablepictureinpicture",
  "disableremoteplayback"
];
var DOM_PROPERTIES = [
  ...DOM_BOOLEAN_ATTRIBUTES,
  "formNoValidate",
  "isMap",
  "noModule",
  "playsInline",
  "readOnly",
  "value",
  "volume",
  "defaultValue",
  "defaultChecked",
  "srcObject",
  "noValidate",
  "allowFullscreen",
  "disablePictureInPicture",
  "disableRemotePlayback"
];
var PASSIVE_EVENTS = ["touchstart", "touchmove"];
function is_passive_event(name) {
  return PASSIVE_EVENTS.includes(name);
}

// node_modules/svelte/src/internal/client/dom/elements/events.js
var all_registered_events = /* @__PURE__ */ new Set();
var root_event_handles = /* @__PURE__ */ new Set();
function handle_event_propagation(event2) {
  var handler_element = this;
  var owner_document = (
    /** @type {Node} */
    handler_element.ownerDocument
  );
  var event_name = event2.type;
  var path = event2.composedPath?.() || [];
  var current_target = (
    /** @type {null | Element} */
    path[0] || event2.target
  );
  var path_idx = 0;
  var handled_at = event2.__root;
  if (handled_at) {
    var at_idx = path.indexOf(handled_at);
    if (at_idx !== -1 && (handler_element === document || handler_element === /** @type {any} */
    window)) {
      event2.__root = handler_element;
      return;
    }
    var handler_idx = path.indexOf(handler_element);
    if (handler_idx === -1) {
      return;
    }
    if (at_idx <= handler_idx) {
      path_idx = at_idx;
    }
  }
  current_target = /** @type {Element} */
  path[path_idx] || event2.target;
  if (current_target === handler_element) return;
  define_property(event2, "currentTarget", {
    configurable: true,
    get() {
      return current_target || owner_document;
    }
  });
  var previous_reaction = active_reaction;
  var previous_effect = active_effect;
  set_active_reaction(null);
  set_active_effect(null);
  try {
    var throw_error;
    var other_errors = [];
    while (current_target !== null) {
      var parent_element = current_target.assignedSlot || current_target.parentNode || /** @type {any} */
      current_target.host || null;
      try {
        var delegated = current_target["__" + event_name];
        if (delegated !== void 0 && !/** @type {any} */
        current_target.disabled) {
          if (is_array(delegated)) {
            var [fn, ...data] = delegated;
            fn.apply(current_target, [event2, ...data]);
          } else {
            delegated.call(current_target, event2);
          }
        }
      } catch (error) {
        if (throw_error) {
          other_errors.push(error);
        } else {
          throw_error = error;
        }
      }
      if (event2.cancelBubble || parent_element === handler_element || parent_element === null) {
        break;
      }
      current_target = parent_element;
    }
    if (throw_error) {
      for (let error of other_errors) {
        queueMicrotask(() => {
          throw error;
        });
      }
      throw throw_error;
    }
  } finally {
    event2.__root = handler_element;
    delete event2.currentTarget;
    set_active_reaction(previous_reaction);
    set_active_effect(previous_effect);
  }
}

// node_modules/svelte/src/internal/client/dom/blocks/svelte-head.js
var head_anchor;
function reset_head_anchor() {
  head_anchor = void 0;
}

// node_modules/svelte/src/internal/client/dom/template.js
function assign_nodes(start, end) {
  var effect2 = (
    /** @type {Effect} */
    active_effect
  );
  if (effect2.nodes_start === null) {
    effect2.nodes_start = start;
    effect2.nodes_end = end;
  }
}
function append(anchor, dom) {
  if (hydrating) {
    active_effect.nodes_end = hydrate_node;
    hydrate_next();
    return;
  }
  if (anchor === null) {
    return;
  }
  anchor.before(
    /** @type {Node} */
    dom
  );
}

// node_modules/svelte/src/internal/client/render.js
var should_intro = true;
function mount(component2, options) {
  return _mount(component2, options);
}
function hydrate(component2, options) {
  init_operations();
  options.intro = options.intro ?? false;
  const target = options.target;
  const was_hydrating = hydrating;
  const previous_hydrate_node = hydrate_node;
  try {
    var anchor = (
      /** @type {TemplateNode} */
      get_first_child(target)
    );
    while (anchor && (anchor.nodeType !== 8 || /** @type {Comment} */
    anchor.data !== HYDRATION_START)) {
      anchor = /** @type {TemplateNode} */
      get_next_sibling(anchor);
    }
    if (!anchor) {
      throw HYDRATION_ERROR;
    }
    set_hydrating(true);
    set_hydrate_node(
      /** @type {Comment} */
      anchor
    );
    hydrate_next();
    const instance = _mount(component2, { ...options, anchor });
    if (hydrate_node === null || hydrate_node.nodeType !== 8 || /** @type {Comment} */
    hydrate_node.data !== HYDRATION_END) {
      hydration_mismatch();
      throw HYDRATION_ERROR;
    }
    set_hydrating(false);
    return (
      /**  @type {Exports} */
      instance
    );
  } catch (error) {
    if (error === HYDRATION_ERROR) {
      if (options.recover === false) {
        hydration_failed();
      }
      init_operations();
      clear_text_content(target);
      set_hydrating(false);
      return mount(component2, options);
    }
    throw error;
  } finally {
    set_hydrating(was_hydrating);
    set_hydrate_node(previous_hydrate_node);
    reset_head_anchor();
  }
}
var document_listeners = /* @__PURE__ */ new Map();
function _mount(Component, { target, anchor, props = {}, events, context, intro = true }) {
  init_operations();
  var registered_events = /* @__PURE__ */ new Set();
  var event_handle = (events2) => {
    for (var i = 0; i < events2.length; i++) {
      var event_name = events2[i];
      if (registered_events.has(event_name)) continue;
      registered_events.add(event_name);
      var passive2 = is_passive_event(event_name);
      target.addEventListener(event_name, handle_event_propagation, { passive: passive2 });
      var n = document_listeners.get(event_name);
      if (n === void 0) {
        document.addEventListener(event_name, handle_event_propagation, { passive: passive2 });
        document_listeners.set(event_name, 1);
      } else {
        document_listeners.set(event_name, n + 1);
      }
    }
  };
  event_handle(array_from(all_registered_events));
  root_event_handles.add(event_handle);
  var component2 = void 0;
  var unmount3 = component_root(() => {
    var anchor_node = anchor ?? target.appendChild(create_text());
    branch(() => {
      if (context) {
        push({});
        var ctx = (
          /** @type {ComponentContext} */
          component_context
        );
        ctx.c = context;
      }
      if (events) {
        props.$$events = events;
      }
      if (hydrating) {
        assign_nodes(
          /** @type {TemplateNode} */
          anchor_node,
          null
        );
      }
      should_intro = intro;
      component2 = Component(anchor_node, props) || {};
      should_intro = true;
      if (hydrating) {
        active_effect.nodes_end = hydrate_node;
      }
      if (context) {
        pop();
      }
    });
    return () => {
      for (var event_name of registered_events) {
        target.removeEventListener(event_name, handle_event_propagation);
        var n = (
          /** @type {number} */
          document_listeners.get(event_name)
        );
        if (--n === 0) {
          document.removeEventListener(event_name, handle_event_propagation);
          document_listeners.delete(event_name);
        } else {
          document_listeners.set(event_name, n);
        }
      }
      root_event_handles.delete(event_handle);
      if (anchor_node !== anchor) {
        anchor_node.parentNode?.removeChild(anchor_node);
      }
    };
  });
  mounted_components.set(component2, unmount3);
  return component2;
}
var mounted_components = /* @__PURE__ */ new WeakMap();
function unmount(component2, options) {
  const fn = mounted_components.get(component2);
  if (fn) {
    mounted_components.delete(component2);
    return fn(options);
  }
  if (true_default) {
    lifecycle_double_unmount();
  }
  return Promise.resolve();
}

// node_modules/svelte/src/internal/client/reactivity/store.js
var IS_UNMOUNTED = Symbol();

// node_modules/svelte/src/legacy/legacy-client.js
function createClassComponent(options) {
  return new Svelte4Component(options);
}
var Svelte4Component = class {
  /** @type {any} */
  #events;
  /** @type {Record<string, any>} */
  #instance;
  /**
   * @param {ComponentConstructorOptions & {
   *  component: any;
   * }} options
   */
  constructor(options) {
    var sources = /* @__PURE__ */ new Map();
    var add_source = (key, value) => {
      var s = mutable_source(value);
      sources.set(key, s);
      return s;
    };
    const props = new Proxy(
      { ...options.props || {}, $$events: {} },
      {
        get(target, prop2) {
          return get(sources.get(prop2) ?? add_source(prop2, Reflect.get(target, prop2)));
        },
        has(target, prop2) {
          if (prop2 === LEGACY_PROPS) return true;
          get(sources.get(prop2) ?? add_source(prop2, Reflect.get(target, prop2)));
          return Reflect.has(target, prop2);
        },
        set(target, prop2, value) {
          set(sources.get(prop2) ?? add_source(prop2, value), value);
          return Reflect.set(target, prop2, value);
        }
      }
    );
    this.#instance = (options.hydrate ? hydrate : mount)(options.component, {
      target: options.target,
      anchor: options.anchor,
      props,
      context: options.context,
      intro: options.intro ?? false,
      recover: options.recover
    });
    if (!options?.props?.$$host || options.sync === false) {
      flush_sync();
    }
    this.#events = props.$$events;
    for (const key of Object.keys(this.#instance)) {
      if (key === "$set" || key === "$destroy" || key === "$on") continue;
      define_property(this, key, {
        get() {
          return this.#instance[key];
        },
        /** @param {any} value */
        set(value) {
          this.#instance[key] = value;
        },
        enumerable: true
      });
    }
    this.#instance.$set = /** @param {Record<string, any>} next */
    (next2) => {
      Object.assign(props, next2);
    };
    this.#instance.$destroy = () => {
      unmount(this.#instance);
    };
  }
  /** @param {Record<string, any>} props */
  $set(props) {
    this.#instance.$set(props);
  }
  /**
   * @param {string} event
   * @param {(...args: any[]) => any} callback
   * @returns {any}
   */
  $on(event2, callback) {
    this.#events[event2] = this.#events[event2] || [];
    const cb = (...args) => callback.call(this, ...args);
    this.#events[event2].push(cb);
    return () => {
      this.#events[event2] = this.#events[event2].filter(
        /** @param {any} fn */
        (fn) => fn !== cb
      );
    };
  }
  $destroy() {
    this.#instance.$destroy();
  }
};

// node_modules/svelte/src/internal/client/dom/elements/custom-element.js
var SvelteElement;
if (typeof HTMLElement === "function") {
  SvelteElement = class extends HTMLElement {
    /** The Svelte component constructor */
    $$ctor;
    /** Slots */
    $$s;
    /** @type {any} The Svelte component instance */
    $$c;
    /** Whether or not the custom element is connected */
    $$cn = false;
    /** @type {Record<string, any>} Component props data */
    $$d = {};
    /** `true` if currently in the process of reflecting component props back to attributes */
    $$r = false;
    /** @type {Record<string, CustomElementPropDefinition>} Props definition (name, reflected, type etc) */
    $$p_d = {};
    /** @type {Record<string, EventListenerOrEventListenerObject[]>} Event listeners */
    $$l = {};
    /** @type {Map<EventListenerOrEventListenerObject, Function>} Event listener unsubscribe functions */
    $$l_u = /* @__PURE__ */ new Map();
    /** @type {any} The managed render effect for reflecting attributes */
    $$me;
    /**
     * @param {*} $$componentCtor
     * @param {*} $$slots
     * @param {*} use_shadow_dom
     */
    constructor($$componentCtor, $$slots, use_shadow_dom) {
      super();
      this.$$ctor = $$componentCtor;
      this.$$s = $$slots;
      if (use_shadow_dom) {
        this.attachShadow({ mode: "open" });
      }
    }
    /**
     * @param {string} type
     * @param {EventListenerOrEventListenerObject} listener
     * @param {boolean | AddEventListenerOptions} [options]
     */
    addEventListener(type, listener, options) {
      this.$$l[type] = this.$$l[type] || [];
      this.$$l[type].push(listener);
      if (this.$$c) {
        const unsub = this.$$c.$on(type, listener);
        this.$$l_u.set(listener, unsub);
      }
      super.addEventListener(type, listener, options);
    }
    /**
     * @param {string} type
     * @param {EventListenerOrEventListenerObject} listener
     * @param {boolean | AddEventListenerOptions} [options]
     */
    removeEventListener(type, listener, options) {
      super.removeEventListener(type, listener, options);
      if (this.$$c) {
        const unsub = this.$$l_u.get(listener);
        if (unsub) {
          unsub();
          this.$$l_u.delete(listener);
        }
      }
    }
    async connectedCallback() {
      this.$$cn = true;
      if (!this.$$c) {
        let create_slot2 = function(name) {
          return (anchor) => {
            const slot2 = document.createElement("slot");
            if (name !== "default") slot2.name = name;
            append(anchor, slot2);
          };
        };
        var create_slot = create_slot2;
        await Promise.resolve();
        if (!this.$$cn || this.$$c) {
          return;
        }
        const $$slots = {};
        const existing_slots = get_custom_elements_slots(this);
        for (const name of this.$$s) {
          if (name in existing_slots) {
            if (name === "default" && !this.$$d.children) {
              this.$$d.children = create_slot2(name);
              $$slots.default = true;
            } else {
              $$slots[name] = create_slot2(name);
            }
          }
        }
        for (const attribute of this.attributes) {
          const name = this.$$g_p(attribute.name);
          if (!(name in this.$$d)) {
            this.$$d[name] = get_custom_element_value(name, attribute.value, this.$$p_d, "toProp");
          }
        }
        for (const key in this.$$p_d) {
          if (!(key in this.$$d) && this[key] !== void 0) {
            this.$$d[key] = this[key];
            delete this[key];
          }
        }
        this.$$c = createClassComponent({
          component: this.$$ctor,
          target: this.shadowRoot || this,
          props: {
            ...this.$$d,
            $$slots,
            $$host: this
          }
        });
        this.$$me = effect_root(() => {
          render_effect(() => {
            this.$$r = true;
            for (const key of object_keys(this.$$c)) {
              if (!this.$$p_d[key]?.reflect) continue;
              this.$$d[key] = this.$$c[key];
              const attribute_value = get_custom_element_value(
                key,
                this.$$d[key],
                this.$$p_d,
                "toAttribute"
              );
              if (attribute_value == null) {
                this.removeAttribute(this.$$p_d[key].attribute || key);
              } else {
                this.setAttribute(this.$$p_d[key].attribute || key, attribute_value);
              }
            }
            this.$$r = false;
          });
        });
        for (const type in this.$$l) {
          for (const listener of this.$$l[type]) {
            const unsub = this.$$c.$on(type, listener);
            this.$$l_u.set(listener, unsub);
          }
        }
        this.$$l = {};
      }
    }
    // We don't need this when working within Svelte code, but for compatibility of people using this outside of Svelte
    // and setting attributes through setAttribute etc, this is helpful
    /**
     * @param {string} attr
     * @param {string} _oldValue
     * @param {string} newValue
     */
    attributeChangedCallback(attr2, _oldValue, newValue) {
      if (this.$$r) return;
      attr2 = this.$$g_p(attr2);
      this.$$d[attr2] = get_custom_element_value(attr2, newValue, this.$$p_d, "toProp");
      this.$$c?.$set({ [attr2]: this.$$d[attr2] });
    }
    disconnectedCallback() {
      this.$$cn = false;
      Promise.resolve().then(() => {
        if (!this.$$cn && this.$$c) {
          this.$$c.$destroy();
          this.$$me();
          this.$$c = void 0;
        }
      });
    }
    /**
     * @param {string} attribute_name
     */
    $$g_p(attribute_name) {
      return object_keys(this.$$p_d).find(
        (key) => this.$$p_d[key].attribute === attribute_name || !this.$$p_d[key].attribute && key.toLowerCase() === attribute_name
      ) || attribute_name;
    }
  };
}
function get_custom_element_value(prop2, value, props_definition, transform) {
  const type = props_definition[prop2]?.type;
  value = type === "Boolean" && typeof value !== "boolean" ? value != null : value;
  if (!transform || !props_definition[prop2]) {
    return value;
  } else if (transform === "toAttribute") {
    switch (type) {
      case "Object":
      case "Array":
        return value == null ? null : JSON.stringify(value);
      case "Boolean":
        return value ? "" : null;
      case "Number":
        return value == null ? null : value;
      default:
        return value;
    }
  } else {
    switch (type) {
      case "Object":
      case "Array":
        return value && JSON.parse(value);
      case "Boolean":
        return value;
      // conversion already handled above
      case "Number":
        return value != null ? +value : value;
      default:
        return value;
    }
  }
}
function get_custom_elements_slots(element2) {
  const result = {};
  element2.childNodes.forEach((node) => {
    result[
      /** @type {Element} node */
      node.slot || "default"
    ] = true;
  });
  return result;
}

// node_modules/svelte/src/index-client.js
if (true_default) {
  let throw_rune_error = function(rune) {
    if (!(rune in globalThis)) {
      let value;
      Object.defineProperty(globalThis, rune, {
        configurable: true,
        // eslint-disable-next-line getter-return
        get: () => {
          if (value !== void 0) {
            return value;
          }
          rune_outside_svelte(rune);
        },
        set: (v) => {
          value = v;
        }
      });
    }
  };
  throw_rune_error2 = throw_rune_error;
  throw_rune_error("$state");
  throw_rune_error("$effect");
  throw_rune_error("$derived");
  throw_rune_error("$inspect");
  throw_rune_error("$props");
  throw_rune_error("$bindable");
}
var throw_rune_error2;

// node_modules/svelte/src/internal/server/context.js
var current_component = null;
function push2(fn) {
  current_component = { p: current_component, c: null, d: null };
  if (true_default) {
    current_component.function = fn;
  }
}
function pop2() {
  var component2 = (
    /** @type {Component} */
    current_component
  );
  var ondestroy = component2.d;
  if (ondestroy) {
    on_destroy.push(...ondestroy);
  }
  current_component = component2.p;
}

// node_modules/svelte/src/internal/server/hydration.js
var BLOCK_OPEN = `<!--${HYDRATION_START}-->`;
var BLOCK_OPEN_ELSE = `<!--${HYDRATION_START_ELSE}-->`;
var BLOCK_CLOSE = `<!--${HYDRATION_END}-->`;

// node_modules/svelte/src/html-tree-validation.js
var autoclosing_children = {
  // based on http://developers.whatwg.org/syntax.html#syntax-tag-omission
  li: { direct: ["li"] },
  // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dt#technical_summary
  dt: { descendant: ["dt", "dd"], reset_by: ["dl"] },
  dd: { descendant: ["dt", "dd"], reset_by: ["dl"] },
  p: {
    descendant: [
      "address",
      "article",
      "aside",
      "blockquote",
      "div",
      "dl",
      "fieldset",
      "footer",
      "form",
      "h1",
      "h2",
      "h3",
      "h4",
      "h5",
      "h6",
      "header",
      "hgroup",
      "hr",
      "main",
      "menu",
      "nav",
      "ol",
      "p",
      "pre",
      "section",
      "table",
      "ul"
    ]
  },
  rt: { descendant: ["rt", "rp"] },
  rp: { descendant: ["rt", "rp"] },
  optgroup: { descendant: ["optgroup"] },
  option: { descendant: ["option", "optgroup"] },
  thead: { direct: ["tbody", "tfoot"] },
  tbody: { direct: ["tbody", "tfoot"] },
  tfoot: { direct: ["tbody"] },
  tr: { direct: ["tr", "tbody"] },
  td: { direct: ["td", "th", "tr"] },
  th: { direct: ["td", "th", "tr"] }
};
var disallowed_children = {
  ...autoclosing_children,
  optgroup: { only: ["option", "#text"] },
  // Strictly speaking, seeing an <option> doesn't mean we're in a <select>, but we assume it here
  option: { only: ["#text"] },
  form: { descendant: ["form"] },
  a: { descendant: ["a"] },
  button: { descendant: ["button"] },
  h1: { descendant: ["h1", "h2", "h3", "h4", "h5", "h6"] },
  h2: { descendant: ["h1", "h2", "h3", "h4", "h5", "h6"] },
  h3: { descendant: ["h1", "h2", "h3", "h4", "h5", "h6"] },
  h4: { descendant: ["h1", "h2", "h3", "h4", "h5", "h6"] },
  h5: { descendant: ["h1", "h2", "h3", "h4", "h5", "h6"] },
  h6: { descendant: ["h1", "h2", "h3", "h4", "h5", "h6"] },
  // https://html.spec.whatwg.org/multipage/syntax.html#parsing-main-inselect
  select: { only: ["option", "optgroup", "#text", "hr", "script", "template"] },
  // https://html.spec.whatwg.org/multipage/syntax.html#parsing-main-intd
  // https://html.spec.whatwg.org/multipage/syntax.html#parsing-main-incaption
  // No special behavior since these rules fall back to "in body" mode for
  // all except special table nodes which cause bad parsing behavior anyway.
  // https://html.spec.whatwg.org/multipage/syntax.html#parsing-main-intd
  tr: { only: ["th", "td", "style", "script", "template"] },
  // https://html.spec.whatwg.org/multipage/syntax.html#parsing-main-intbody
  tbody: { only: ["tr", "style", "script", "template"] },
  thead: { only: ["tr", "style", "script", "template"] },
  tfoot: { only: ["tr", "style", "script", "template"] },
  // https://html.spec.whatwg.org/multipage/syntax.html#parsing-main-incolgroup
  colgroup: { only: ["col", "template"] },
  // https://html.spec.whatwg.org/multipage/syntax.html#parsing-main-intable
  table: {
    only: ["caption", "colgroup", "tbody", "thead", "tfoot", "style", "script", "template"]
  },
  // https://html.spec.whatwg.org/multipage/syntax.html#parsing-main-inhead
  head: {
    only: [
      "base",
      "basefont",
      "bgsound",
      "link",
      "meta",
      "title",
      "noscript",
      "noframes",
      "style",
      "script",
      "template"
    ]
  },
  // https://html.spec.whatwg.org/multipage/semantics.html#the-html-element
  html: { only: ["head", "body", "frameset"] },
  frameset: { only: ["frame"] },
  "#document": { only: ["html"] }
};
function is_tag_valid_with_ancestor(child_tag, ancestors, child_loc, ancestor_loc) {
  if (child_tag.includes("-")) return null;
  const ancestor_tag = ancestors[ancestors.length - 1];
  const disallowed = disallowed_children[ancestor_tag];
  if (!disallowed) return null;
  if ("reset_by" in disallowed && disallowed.reset_by) {
    for (let i = ancestors.length - 2; i >= 0; i--) {
      const ancestor = ancestors[i];
      if (ancestor.includes("-")) return null;
      if (disallowed.reset_by.includes(ancestors[i])) {
        return null;
      }
    }
  }
  if ("descendant" in disallowed && disallowed.descendant.includes(child_tag)) {
    const child2 = child_loc ? `\`<${child_tag}>\` (${child_loc})` : `\`<${child_tag}>\``;
    const ancestor = ancestor_loc ? `\`<${ancestor_tag}>\` (${ancestor_loc})` : `\`<${ancestor_tag}>\``;
    return `${child2} cannot be a descendant of ${ancestor}`;
  }
  return null;
}
function is_tag_valid_with_parent(child_tag, parent_tag, child_loc, parent_loc) {
  if (child_tag.includes("-") || parent_tag?.includes("-")) return null;
  if (parent_tag === "template") return null;
  const disallowed = disallowed_children[parent_tag];
  const child2 = child_loc ? `\`<${child_tag}>\` (${child_loc})` : `\`<${child_tag}>\``;
  const parent2 = parent_loc ? `\`<${parent_tag}>\` (${parent_loc})` : `\`<${parent_tag}>\``;
  if (disallowed) {
    if ("direct" in disallowed && disallowed.direct.includes(child_tag)) {
      return `${child2} cannot be a direct child of ${parent2}`;
    }
    if ("descendant" in disallowed && disallowed.descendant.includes(child_tag)) {
      return `${child2} cannot be a child of ${parent2}`;
    }
    if ("only" in disallowed && disallowed.only) {
      if (disallowed.only.includes(child_tag)) {
        return null;
      } else {
        return `${child2} cannot be a child of ${parent2}. \`<${parent_tag}>\` only allows these children: ${disallowed.only.map((d) => `\`<${d}>\``).join(", ")}`;
      }
    }
  }
  switch (child_tag) {
    case "body":
    case "caption":
    case "col":
    case "colgroup":
    case "frameset":
    case "frame":
    case "head":
    case "html":
      return `${child2} cannot be a child of ${parent2}`;
    case "thead":
    case "tbody":
    case "tfoot":
      return `${child2} must be the child of a \`<table>\`, not a ${parent2}`;
    case "td":
    case "th":
      return `${child2} must be the child of a \`<tr>\`, not a ${parent2}`;
    case "tr":
      return `\`<tr>\` must be the child of a \`<thead>\`, \`<tbody>\`, or \`<tfoot>\`, not a ${parent2}`;
  }
  return null;
}

// node_modules/svelte/src/internal/server/dev.js
var parent = null;
var seen;
function print_error(payload, message) {
  message = `node_invalid_placement_ssr: ${message}

This can cause content to shift around as the browser repairs the HTML, and will likely result in a \`hydration_mismatch\` warning.`;
  if ((seen ??= /* @__PURE__ */ new Set()).has(message)) return;
  seen.add(message);
  console.error(message);
  payload.head.out += `<script>console.error(${JSON.stringify(message)})</script>`;
}
function reset_elements() {
  let old_parent = parent;
  parent = null;
  return () => {
    parent = old_parent;
  };
}
function push_element(payload, tag, line, column) {
  var filename = (
    /** @type {Component} */
    current_component.function[FILENAME]
  );
  var child2 = { tag, parent, filename, line, column };
  if (parent !== null) {
    var ancestor = parent.parent;
    var ancestors = [parent.tag];
    const child_loc = filename ? `${filename}:${line}:${column}` : void 0;
    const parent_loc = parent.filename ? `${parent.filename}:${parent.line}:${parent.column}` : void 0;
    const message = is_tag_valid_with_parent(tag, parent.tag, child_loc, parent_loc);
    if (message) print_error(payload, message);
    while (ancestor != null) {
      ancestors.push(ancestor.tag);
      const ancestor_loc = ancestor.filename ? `${ancestor.filename}:${ancestor.line}:${ancestor.column}` : void 0;
      const message2 = is_tag_valid_with_ancestor(tag, ancestors, child_loc, ancestor_loc);
      if (message2) print_error(payload, message2);
      ancestor = ancestor.parent;
    }
  }
  parent = child2;
}
function pop_element() {
  parent = /** @type {Element} */
  parent.parent;
}

// node_modules/svelte/src/internal/server/index.js
var on_destroy = [];
function props_id_generator() {
  let uid = 1;
  return () => "s" + uid++;
}
function render(component2, options = {}) {
  const uid = options.uid ?? props_id_generator();
  const payload = {
    out: "",
    css: /* @__PURE__ */ new Set(),
    head: { title: "", out: "", css: /* @__PURE__ */ new Set(), uid },
    uid
  };
  const prev_on_destroy = on_destroy;
  on_destroy = [];
  payload.out += BLOCK_OPEN;
  let reset_reset_element;
  if (true_default) {
    reset_reset_element = reset_elements();
  }
  if (options.context) {
    push2();
    current_component.c = options.context;
  }
  component2(payload, options.props ?? {}, {}, {});
  if (options.context) {
    pop2();
  }
  if (reset_reset_element) {
    reset_reset_element();
  }
  payload.out += BLOCK_CLOSE;
  for (const cleanup of on_destroy) cleanup();
  on_destroy = prev_on_destroy;
  let head2 = payload.head.out + payload.head.title;
  for (const { hash: hash2, code } of payload.css) {
    head2 += `<style id="${hash2}">${code}</style>`;
  }
  return {
    head: head2,
    html: payload.out,
    body: payload.out
  };
}
function bind_props(props_parent, props_now) {
  for (const key in props_now) {
    const initial_value = props_parent[key];
    const value = props_now[key];
    if (initial_value === void 0 && value !== void 0 && Object.getOwnPropertyDescriptor(props_parent, key)?.set) {
      props_parent[key] = value;
    }
  }
}

// svelte/Example.svelte
Example[FILENAME] = "svelte/Example.svelte";
function Example($$payload, $$props) {
  push2(Example);
  let number = fallback($$props["number"], 1);
  let live = $$props["live"];
  function increase() {
    live.pushEvent("set_number", { number: number + 1 }, () => {
    });
  }
  function decrease() {
    live.pushEvent("set_number", { number: number - 1 }, () => {
    });
  }
  $$payload.out += `<div class="text-zinc-400">`;
  push_element($$payload, "div", 21, 0);
  $$payload.out += `<p>`;
  push_element($$payload, "p", 22, 2);
  $$payload.out += `The number is ${escape_html(number)}</p>`;
  pop_element();
  $$payload.out += ` <button>`;
  push_element($$payload, "button", 23, 2);
  $$payload.out += `+</button>`;
  pop_element();
  $$payload.out += ` <button>`;
  push_element($$payload, "button", 24, 2);
  $$payload.out += `-</button>`;
  pop_element();
  $$payload.out += `</div>`;
  pop_element();
  bind_props($$props, { number, live });
  pop2();
}
Example.render = function() {
  throw new Error("Component.render(...) is no longer valid in Svelte 5. See https://svelte.dev/docs/svelte/v5-migration-guide#Components-are-no-longer-classes for more information");
};
var Example_default = Example;

// import-glob:../svelte/**/*.svelte
var modules = [Example_exports];
var __default = modules;
var filenames = ["../svelte/Example.svelte"];

// node_modules/svelte/src/internal/server/blocks/snippet.js
function createRawSnippet2(fn) {
  return (payload, ...args) => {
    var getters = (
      /** @type {Getters<Params>} */
      args.map((value) => () => value)
    );
    payload.out += fn(...getters).render().trim();
  };
}

// ../deps/live_svelte/priv/static/live_svelte.esm.js
function normalizeComponents(components) {
  if (!Array.isArray(components.default) || !Array.isArray(components.filenames)) return components;
  const normalized = {};
  for (const [index2, module2] of components.default.entries()) {
    const Component = module2.default;
    const name = components.filenames[index2].replace("../svelte/", "").replace(".svelte", "");
    normalized[name] = Component;
  }
  return normalized;
}
function getRender(components) {
  components = normalizeComponents(components);
  return function r(name, props, slots) {
    const snippets = Object.fromEntries(
      Object.entries(slots).map(([slotName, v]) => {
        const snippet2 = createRawSnippet2((name2) => {
          return {
            render: () => v
          };
        });
        if (slotName === "default") return ["children", snippet2];
        else return [slotName, snippet2];
      })
    );
    return render(components[name], { props: { ...props, ...snippets } });
  };
}

// js/server.js
var render2 = getRender(__exports);
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  render
});
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsiLi4vLi4vYXNzZXRzL2pzL3NlcnZlci5qcyIsICIuLi9zdmVsdGUvKiovKi5zdmVsdGUiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2NvbnN0YW50cy5qcyIsICIuLi8uLi9hc3NldHMvbm9kZV9tb2R1bGVzL3N2ZWx0ZS9zcmMvZXNjYXBpbmcuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL3NoYXJlZC91dGlscy5qcyIsICIuLi8uLi9hc3NldHMvbm9kZV9tb2R1bGVzL2VzbS1lbnYvdHJ1ZS5qcyIsICIuLi8uLi9hc3NldHMvbm9kZV9tb2R1bGVzL3N2ZWx0ZS9zcmMvaW50ZXJuYWwvY2xpZW50L2NvbnN0YW50cy5qcyIsICIuLi8uLi9hc3NldHMvbm9kZV9tb2R1bGVzL3N2ZWx0ZS9zcmMvaW50ZXJuYWwvY2xpZW50L3JlYWN0aXZpdHkvZXF1YWxpdHkuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL2NsaWVudC9lcnJvcnMuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL2ZsYWdzL2luZGV4LmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvZGV2L3RyYWNpbmcuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL2NsaWVudC93YXJuaW5ncy5qcyIsICIuLi8uLi9hc3NldHMvbm9kZV9tb2R1bGVzL3N2ZWx0ZS9zcmMvaW50ZXJuYWwvY2xpZW50L2Rldi9vd25lcnNoaXAuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL2NsaWVudC9jb250ZXh0LmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvcmVhY3Rpdml0eS9zb3VyY2VzLmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvZG9tL2h5ZHJhdGlvbi5qcyIsICIuLi8uLi9hc3NldHMvbm9kZV9tb2R1bGVzL3N2ZWx0ZS9zcmMvaW50ZXJuYWwvY2xpZW50L3Byb3h5LmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvZGV2L2VxdWFsaXR5LmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvZG9tL29wZXJhdGlvbnMuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL2NsaWVudC9yZWFjdGl2aXR5L2Rlcml2ZWRzLmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvcmVhY3Rpdml0eS9lZmZlY3RzLmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvZG9tL3Rhc2suanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL2NsaWVudC9ydW50aW1lLmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy91dGlscy5qcyIsICIuLi8uLi9hc3NldHMvbm9kZV9tb2R1bGVzL3N2ZWx0ZS9zcmMvaW50ZXJuYWwvY2xpZW50L2RvbS9lbGVtZW50cy9ldmVudHMuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL2NsaWVudC9kb20vYmxvY2tzL3N2ZWx0ZS1oZWFkLmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvZG9tL3RlbXBsYXRlLmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvcmVuZGVyLmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9jbGllbnQvcmVhY3Rpdml0eS9zdG9yZS5qcyIsICIuLi8uLi9hc3NldHMvbm9kZV9tb2R1bGVzL3N2ZWx0ZS9zcmMvbGVnYWN5L2xlZ2FjeS1jbGllbnQuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL2NsaWVudC9kb20vZWxlbWVudHMvY3VzdG9tLWVsZW1lbnQuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2luZGV4LWNsaWVudC5qcyIsICIuLi8uLi9hc3NldHMvbm9kZV9tb2R1bGVzL3N2ZWx0ZS9zcmMvaW50ZXJuYWwvc2VydmVyL2NvbnRleHQuanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL3NlcnZlci9oeWRyYXRpb24uanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2h0bWwtdHJlZS12YWxpZGF0aW9uLmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9zZXJ2ZXIvZGV2LmpzIiwgIi4uLy4uL2Fzc2V0cy9ub2RlX21vZHVsZXMvc3ZlbHRlL3NyYy9pbnRlcm5hbC9zZXJ2ZXIvaW5kZXguanMiLCAiLi4vLi4vYXNzZXRzL25vZGVfbW9kdWxlcy9zdmVsdGUvc3JjL2ludGVybmFsL3NlcnZlci9ibG9ja3Mvc25pcHBldC5qcyIsICIuLi8uLi9kZXBzL2xpdmVfc3ZlbHRlL2Fzc2V0cy9qcy9saXZlX3N2ZWx0ZS91dGlscy5qcyIsICIuLi8uLi9kZXBzL2xpdmVfc3ZlbHRlL2Fzc2V0cy9qcy9saXZlX3N2ZWx0ZS9yZW5kZXIuanMiLCAiLi4vLi4vZGVwcy9saXZlX3N2ZWx0ZS9hc3NldHMvanMvbGl2ZV9zdmVsdGUvaG9va3Muc3ZlbHRlLmpzIl0sCiAgInNvdXJjZXNDb250ZW50IjogWyJpbXBvcnQgKiBhcyBDb21wb25lbnRzIGZyb20gXCIuLi9zdmVsdGUvKiovKi5zdmVsdGVcIjtcbmltcG9ydCB7IGdldFJlbmRlciB9IGZyb20gXCJsaXZlX3N2ZWx0ZVwiO1xuXG5leHBvcnQgY29uc3QgcmVuZGVyID0gZ2V0UmVuZGVyKENvbXBvbmVudHMpO1xuIiwgIlxuICAgICAgICBpbXBvcnQgKiBhcyBtb2R1bGUwIGZyb20gJy4uL3N2ZWx0ZS9FeGFtcGxlLnN2ZWx0ZSdcblxuICAgICAgICBjb25zdCBtb2R1bGVzID0gW21vZHVsZTBdO1xuXG4gICAgICAgIGV4cG9ydCBkZWZhdWx0IG1vZHVsZXM7XG4gICAgICAgIGV4cG9ydCBjb25zdCBmaWxlbmFtZXMgPSBbJy4uL3N2ZWx0ZS9FeGFtcGxlLnN2ZWx0ZSddXG4gICAgICAiLCAiZXhwb3J0IGNvbnN0IEVBQ0hfSVRFTV9SRUFDVElWRSA9IDE7XG5leHBvcnQgY29uc3QgRUFDSF9JTkRFWF9SRUFDVElWRSA9IDEgPDwgMTtcbi8qKiBTZWUgRWFjaEJsb2NrIGludGVyZmFjZSBtZXRhZGF0YS5pc19jb250cm9sbGVkIGZvciBhbiBleHBsYW5hdGlvbiB3aGF0IHRoaXMgaXMgKi9cbmV4cG9ydCBjb25zdCBFQUNIX0lTX0NPTlRST0xMRUQgPSAxIDw8IDI7XG5leHBvcnQgY29uc3QgRUFDSF9JU19BTklNQVRFRCA9IDEgPDwgMztcbmV4cG9ydCBjb25zdCBFQUNIX0lURU1fSU1NVVRBQkxFID0gMSA8PCA0O1xuXG5leHBvcnQgY29uc3QgUFJPUFNfSVNfSU1NVVRBQkxFID0gMTtcbmV4cG9ydCBjb25zdCBQUk9QU19JU19SVU5FUyA9IDEgPDwgMTtcbmV4cG9ydCBjb25zdCBQUk9QU19JU19VUERBVEVEID0gMSA8PCAyO1xuZXhwb3J0IGNvbnN0IFBST1BTX0lTX0JJTkRBQkxFID0gMSA8PCAzO1xuZXhwb3J0IGNvbnN0IFBST1BTX0lTX0xBWllfSU5JVElBTCA9IDEgPDwgNDtcblxuZXhwb3J0IGNvbnN0IFRSQU5TSVRJT05fSU4gPSAxO1xuZXhwb3J0IGNvbnN0IFRSQU5TSVRJT05fT1VUID0gMSA8PCAxO1xuZXhwb3J0IGNvbnN0IFRSQU5TSVRJT05fR0xPQkFMID0gMSA8PCAyO1xuXG5leHBvcnQgY29uc3QgVEVNUExBVEVfRlJBR01FTlQgPSAxO1xuZXhwb3J0IGNvbnN0IFRFTVBMQVRFX1VTRV9JTVBPUlRfTk9ERSA9IDEgPDwgMTtcblxuZXhwb3J0IGNvbnN0IEhZRFJBVElPTl9TVEFSVCA9ICdbJztcbi8qKiB1c2VkIHRvIGluZGljYXRlIHRoYXQgYW4gYHs6ZWxzZX0uLi5gIGJsb2NrIHdhcyByZW5kZXJlZCAqL1xuZXhwb3J0IGNvbnN0IEhZRFJBVElPTl9TVEFSVF9FTFNFID0gJ1shJztcbmV4cG9ydCBjb25zdCBIWURSQVRJT05fRU5EID0gJ10nO1xuZXhwb3J0IGNvbnN0IEhZRFJBVElPTl9FUlJPUiA9IHt9O1xuXG5leHBvcnQgY29uc3QgRUxFTUVOVF9JU19OQU1FU1BBQ0VEID0gMTtcbmV4cG9ydCBjb25zdCBFTEVNRU5UX1BSRVNFUlZFX0FUVFJJQlVURV9DQVNFID0gMSA8PCAxO1xuXG5leHBvcnQgY29uc3QgVU5JTklUSUFMSVpFRCA9IFN5bWJvbCgpO1xuXG4vLyBEZXYtdGltZSBjb21wb25lbnQgcHJvcGVydGllc1xuZXhwb3J0IGNvbnN0IEZJTEVOQU1FID0gU3ltYm9sKCdmaWxlbmFtZScpO1xuZXhwb3J0IGNvbnN0IEhNUiA9IFN5bWJvbCgnaG1yJyk7XG5cbmV4cG9ydCBjb25zdCBOQU1FU1BBQ0VfU1ZHID0gJ2h0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnJztcbmV4cG9ydCBjb25zdCBOQU1FU1BBQ0VfTUFUSE1MID0gJ2h0dHA6Ly93d3cudzMub3JnLzE5OTgvTWF0aC9NYXRoTUwnO1xuXG4vLyB3ZSB1c2UgYSBsaXN0IG9mIGlnbm9yYWJsZSBydW50aW1lIHdhcm5pbmdzIGJlY2F1c2Ugbm90IGV2ZXJ5IHJ1bnRpbWUgd2FybmluZ1xuLy8gY2FuIGJlIGlnbm9yZWQgYW5kIHdlIHdhbnQgdG8ga2VlcCB0aGUgdmFsaWRhdGlvbiBmb3Igc3ZlbHRlLWlnbm9yZSBpbiBwbGFjZVxuZXhwb3J0IGNvbnN0IElHTk9SQUJMRV9SVU5USU1FX1dBUk5JTkdTID0gLyoqIEB0eXBlIHtjb25zdH0gKi8gKFtcblx0J3N0YXRlX3NuYXBzaG90X3VuY2xvbmVhYmxlJyxcblx0J2JpbmRpbmdfcHJvcGVydHlfbm9uX3JlYWN0aXZlJyxcblx0J2h5ZHJhdGlvbl9hdHRyaWJ1dGVfY2hhbmdlZCcsXG5cdCdoeWRyYXRpb25faHRtbF9jaGFuZ2VkJyxcblx0J293bmVyc2hpcF9pbnZhbGlkX2JpbmRpbmcnLFxuXHQnb3duZXJzaGlwX2ludmFsaWRfbXV0YXRpb24nXG5dKTtcblxuLyoqXG4gKiBXaGl0ZXNwYWNlIGluc2lkZSBvbmUgb2YgdGhlc2UgZWxlbWVudHMgd2lsbCBub3QgcmVzdWx0IGluXG4gKiBhIHdoaXRlc3BhY2Ugbm9kZSBiZWluZyBjcmVhdGVkIGluIGFueSBjaXJjdW1zdGFuY2VzLiAoVGhpc1xuICogbGlzdCBpcyBhbG1vc3QgY2VydGFpbmx5IHZlcnkgaW5jb21wbGV0ZSlcbiAqIFRPRE8gdGhpcyBpcyBjdXJyZW50bHkgdW51c2VkXG4gKi9cbmV4cG9ydCBjb25zdCBFTEVNRU5UU19XSVRIT1VUX1RFWFQgPSBbJ2F1ZGlvJywgJ2RhdGFsaXN0JywgJ2RsJywgJ29wdGdyb3VwJywgJ3NlbGVjdCcsICd2aWRlbyddO1xuIiwgImNvbnN0IEFUVFJfUkVHRVggPSAvWyZcIjxdL2c7XG5jb25zdCBDT05URU5UX1JFR0VYID0gL1smPF0vZztcblxuLyoqXG4gKiBAdGVtcGxhdGUgVlxuICogQHBhcmFtIHtWfSB2YWx1ZVxuICogQHBhcmFtIHtib29sZWFufSBbaXNfYXR0cl1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGVzY2FwZV9odG1sKHZhbHVlLCBpc19hdHRyKSB7XG5cdGNvbnN0IHN0ciA9IFN0cmluZyh2YWx1ZSA/PyAnJyk7XG5cblx0Y29uc3QgcGF0dGVybiA9IGlzX2F0dHIgPyBBVFRSX1JFR0VYIDogQ09OVEVOVF9SRUdFWDtcblx0cGF0dGVybi5sYXN0SW5kZXggPSAwO1xuXG5cdGxldCBlc2NhcGVkID0gJyc7XG5cdGxldCBsYXN0ID0gMDtcblxuXHR3aGlsZSAocGF0dGVybi50ZXN0KHN0cikpIHtcblx0XHRjb25zdCBpID0gcGF0dGVybi5sYXN0SW5kZXggLSAxO1xuXHRcdGNvbnN0IGNoID0gc3RyW2ldO1xuXHRcdGVzY2FwZWQgKz0gc3RyLnN1YnN0cmluZyhsYXN0LCBpKSArIChjaCA9PT0gJyYnID8gJyZhbXA7JyA6IGNoID09PSAnXCInID8gJyZxdW90OycgOiAnJmx0OycpO1xuXHRcdGxhc3QgPSBpICsgMTtcblx0fVxuXG5cdHJldHVybiBlc2NhcGVkICsgc3RyLnN1YnN0cmluZyhsYXN0KTtcbn1cbiIsICIvLyBTdG9yZSB0aGUgcmVmZXJlbmNlcyB0byBnbG9iYWxzIGluIGNhc2Ugc29tZW9uZSB0cmllcyB0byBtb25rZXkgcGF0Y2ggdGhlc2UsIGNhdXNpbmcgdGhlIGJlbG93XG4vLyB0byBkZS1vcHQgKHRoaXMgb2NjdXJzIG9mdGVuIHdoZW4gdXNpbmcgcG9wdWxhciBleHRlbnNpb25zKS5cbmV4cG9ydCB2YXIgaXNfYXJyYXkgPSBBcnJheS5pc0FycmF5O1xuZXhwb3J0IHZhciBpbmRleF9vZiA9IEFycmF5LnByb3RvdHlwZS5pbmRleE9mO1xuZXhwb3J0IHZhciBhcnJheV9mcm9tID0gQXJyYXkuZnJvbTtcbmV4cG9ydCB2YXIgb2JqZWN0X2tleXMgPSBPYmplY3Qua2V5cztcbmV4cG9ydCB2YXIgZGVmaW5lX3Byb3BlcnR5ID0gT2JqZWN0LmRlZmluZVByb3BlcnR5O1xuZXhwb3J0IHZhciBnZXRfZGVzY3JpcHRvciA9IE9iamVjdC5nZXRPd25Qcm9wZXJ0eURlc2NyaXB0b3I7XG5leHBvcnQgdmFyIGdldF9kZXNjcmlwdG9ycyA9IE9iamVjdC5nZXRPd25Qcm9wZXJ0eURlc2NyaXB0b3JzO1xuZXhwb3J0IHZhciBvYmplY3RfcHJvdG90eXBlID0gT2JqZWN0LnByb3RvdHlwZTtcbmV4cG9ydCB2YXIgYXJyYXlfcHJvdG90eXBlID0gQXJyYXkucHJvdG90eXBlO1xuZXhwb3J0IHZhciBnZXRfcHJvdG90eXBlX29mID0gT2JqZWN0LmdldFByb3RvdHlwZU9mO1xuXG4vKipcbiAqIEBwYXJhbSB7YW55fSB0aGluZ1xuICogQHJldHVybnMge3RoaW5nIGlzIEZ1bmN0aW9ufVxuICovXG5leHBvcnQgZnVuY3Rpb24gaXNfZnVuY3Rpb24odGhpbmcpIHtcblx0cmV0dXJuIHR5cGVvZiB0aGluZyA9PT0gJ2Z1bmN0aW9uJztcbn1cblxuZXhwb3J0IGNvbnN0IG5vb3AgPSAoKSA9PiB7fTtcblxuLy8gQWRhcHRlZCBmcm9tIGh0dHBzOi8vZ2l0aHViLmNvbS90aGVuL2lzLXByb21pc2UvYmxvYi9tYXN0ZXIvaW5kZXguanNcbi8vIERpc3RyaWJ1dGVkIHVuZGVyIE1JVCBMaWNlbnNlIGh0dHBzOi8vZ2l0aHViLmNvbS90aGVuL2lzLXByb21pc2UvYmxvYi9tYXN0ZXIvTElDRU5TRVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSBbVD1hbnldXG4gKiBAcGFyYW0ge2FueX0gdmFsdWVcbiAqIEByZXR1cm5zIHt2YWx1ZSBpcyBQcm9taXNlTGlrZTxUPn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGlzX3Byb21pc2UodmFsdWUpIHtcblx0cmV0dXJuIHR5cGVvZiB2YWx1ZT8udGhlbiA9PT0gJ2Z1bmN0aW9uJztcbn1cblxuLyoqIEBwYXJhbSB7RnVuY3Rpb259IGZuICovXG5leHBvcnQgZnVuY3Rpb24gcnVuKGZuKSB7XG5cdHJldHVybiBmbigpO1xufVxuXG4vKiogQHBhcmFtIHtBcnJheTwoKSA9PiB2b2lkPn0gYXJyICovXG5leHBvcnQgZnVuY3Rpb24gcnVuX2FsbChhcnIpIHtcblx0Zm9yICh2YXIgaSA9IDA7IGkgPCBhcnIubGVuZ3RoOyBpKyspIHtcblx0XHRhcnJbaV0oKTtcblx0fVxufVxuXG4vKipcbiAqIFRPRE8gcmVwbGFjZSB3aXRoIFByb21pc2Uud2l0aFJlc29sdmVycyBvbmNlIHN1cHBvcnRlZCB3aWRlbHkgZW5vdWdoXG4gKiBAdGVtcGxhdGUgVFxuICovXG5leHBvcnQgZnVuY3Rpb24gZGVmZXJyZWQoKSB7XG5cdC8qKiBAdHlwZSB7KHZhbHVlOiBUKSA9PiB2b2lkfSAqL1xuXHR2YXIgcmVzb2x2ZTtcblxuXHQvKiogQHR5cGUgeyhyZWFzb246IGFueSkgPT4gdm9pZH0gKi9cblx0dmFyIHJlamVjdDtcblxuXHQvKiogQHR5cGUge1Byb21pc2U8VD59ICovXG5cdHZhciBwcm9taXNlID0gbmV3IFByb21pc2UoKHJlcywgcmVqKSA9PiB7XG5cdFx0cmVzb2x2ZSA9IHJlcztcblx0XHRyZWplY3QgPSByZWo7XG5cdH0pO1xuXG5cdC8vIEB0cy1leHBlY3QtZXJyb3Jcblx0cmV0dXJuIHsgcHJvbWlzZSwgcmVzb2x2ZSwgcmVqZWN0IH07XG59XG5cbi8qKlxuICogQHRlbXBsYXRlIFZcbiAqIEBwYXJhbSB7Vn0gdmFsdWVcbiAqIEBwYXJhbSB7ViB8ICgoKSA9PiBWKX0gZmFsbGJhY2tcbiAqIEBwYXJhbSB7Ym9vbGVhbn0gW2xhenldXG4gKiBAcmV0dXJucyB7Vn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGZhbGxiYWNrKHZhbHVlLCBmYWxsYmFjaywgbGF6eSA9IGZhbHNlKSB7XG5cdHJldHVybiB2YWx1ZSA9PT0gdW5kZWZpbmVkXG5cdFx0PyBsYXp5XG5cdFx0XHQ/IC8qKiBAdHlwZSB7KCkgPT4gVn0gKi8gKGZhbGxiYWNrKSgpXG5cdFx0XHQ6IC8qKiBAdHlwZSB7Vn0gKi8gKGZhbGxiYWNrKVxuXHRcdDogdmFsdWU7XG59XG4iLCAiZXhwb3J0IGRlZmF1bHQgdHJ1ZTtcbiIsICJleHBvcnQgY29uc3QgREVSSVZFRCA9IDEgPDwgMTtcbmV4cG9ydCBjb25zdCBFRkZFQ1QgPSAxIDw8IDI7XG5leHBvcnQgY29uc3QgUkVOREVSX0VGRkVDVCA9IDEgPDwgMztcbmV4cG9ydCBjb25zdCBCTE9DS19FRkZFQ1QgPSAxIDw8IDQ7XG5leHBvcnQgY29uc3QgQlJBTkNIX0VGRkVDVCA9IDEgPDwgNTtcbmV4cG9ydCBjb25zdCBST09UX0VGRkVDVCA9IDEgPDwgNjtcbmV4cG9ydCBjb25zdCBCT1VOREFSWV9FRkZFQ1QgPSAxIDw8IDc7XG5leHBvcnQgY29uc3QgVU5PV05FRCA9IDEgPDwgODtcbmV4cG9ydCBjb25zdCBESVNDT05ORUNURUQgPSAxIDw8IDk7XG5leHBvcnQgY29uc3QgQ0xFQU4gPSAxIDw8IDEwO1xuZXhwb3J0IGNvbnN0IERJUlRZID0gMSA8PCAxMTtcbmV4cG9ydCBjb25zdCBNQVlCRV9ESVJUWSA9IDEgPDwgMTI7XG5leHBvcnQgY29uc3QgSU5FUlQgPSAxIDw8IDEzO1xuZXhwb3J0IGNvbnN0IERFU1RST1lFRCA9IDEgPDwgMTQ7XG5leHBvcnQgY29uc3QgRUZGRUNUX1JBTiA9IDEgPDwgMTU7XG4vKiogJ1RyYW5zcGFyZW50JyBlZmZlY3RzIGRvIG5vdCBjcmVhdGUgYSB0cmFuc2l0aW9uIGJvdW5kYXJ5ICovXG5leHBvcnQgY29uc3QgRUZGRUNUX1RSQU5TUEFSRU5UID0gMSA8PCAxNjtcbi8qKiBTdmVsdGUgNCBsZWdhY3kgbW9kZSBwcm9wcyBuZWVkIHRvIGJlIGhhbmRsZWQgd2l0aCBkZXJpdmVkcyBhbmQgYmUgcmVjb2duaXplZCBlbHNld2hlcmUsIGhlbmNlIHRoZSBkZWRpY2F0ZWQgZmxhZyAqL1xuZXhwb3J0IGNvbnN0IExFR0FDWV9ERVJJVkVEX1BST1AgPSAxIDw8IDE3O1xuZXhwb3J0IGNvbnN0IElOU1BFQ1RfRUZGRUNUID0gMSA8PCAxODtcbmV4cG9ydCBjb25zdCBIRUFEX0VGRkVDVCA9IDEgPDwgMTk7XG5leHBvcnQgY29uc3QgRUZGRUNUX0hBU19ERVJJVkVEID0gMSA8PCAyMDtcblxuZXhwb3J0IGNvbnN0IFNUQVRFX1NZTUJPTCA9IFN5bWJvbCgnJHN0YXRlJyk7XG5leHBvcnQgY29uc3QgU1RBVEVfU1lNQk9MX01FVEFEQVRBID0gU3ltYm9sKCckc3RhdGUgbWV0YWRhdGEnKTtcbmV4cG9ydCBjb25zdCBMRUdBQ1lfUFJPUFMgPSBTeW1ib2woJ2xlZ2FjeSBwcm9wcycpO1xuZXhwb3J0IGNvbnN0IExPQURJTkdfQVRUUl9TWU1CT0wgPSBTeW1ib2woJycpO1xuIiwgIi8qKiBAaW1wb3J0IHsgRXF1YWxzIH0gZnJvbSAnI2NsaWVudCcgKi9cbi8qKiBAdHlwZSB7RXF1YWxzfSAqL1xuZXhwb3J0IGZ1bmN0aW9uIGVxdWFscyh2YWx1ZSkge1xuXHRyZXR1cm4gdmFsdWUgPT09IHRoaXMudjtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge3Vua25vd259IGFcbiAqIEBwYXJhbSB7dW5rbm93bn0gYlxuICogQHJldHVybnMge2Jvb2xlYW59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzYWZlX25vdF9lcXVhbChhLCBiKSB7XG5cdHJldHVybiBhICE9IGFcblx0XHQ/IGIgPT0gYlxuXHRcdDogYSAhPT0gYiB8fCAoYSAhPT0gbnVsbCAmJiB0eXBlb2YgYSA9PT0gJ29iamVjdCcpIHx8IHR5cGVvZiBhID09PSAnZnVuY3Rpb24nO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7dW5rbm93bn0gYVxuICogQHBhcmFtIHt1bmtub3dufSBiXG4gKiBAcmV0dXJucyB7Ym9vbGVhbn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIG5vdF9lcXVhbChhLCBiKSB7XG5cdHJldHVybiBhICE9PSBiO1xufVxuXG4vKiogQHR5cGUge0VxdWFsc30gKi9cbmV4cG9ydCBmdW5jdGlvbiBzYWZlX2VxdWFscyh2YWx1ZSkge1xuXHRyZXR1cm4gIXNhZmVfbm90X2VxdWFsKHZhbHVlLCB0aGlzLnYpO1xufVxuIiwgIi8qIFRoaXMgZmlsZSBpcyBnZW5lcmF0ZWQgYnkgc2NyaXB0cy9wcm9jZXNzLW1lc3NhZ2VzL2luZGV4LmpzLiBEbyBub3QgZWRpdCEgKi9cblxuaW1wb3J0IHsgREVWIH0gZnJvbSAnZXNtLWVudic7XG5cbi8qKlxuICogVXNpbmcgYGJpbmQ6dmFsdWVgIHRvZ2V0aGVyIHdpdGggYSBjaGVja2JveCBpbnB1dCBpcyBub3QgYWxsb3dlZC4gVXNlIGBiaW5kOmNoZWNrZWRgIGluc3RlYWRcbiAqIEByZXR1cm5zIHtuZXZlcn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGJpbmRfaW52YWxpZF9jaGVja2JveF92YWx1ZSgpIHtcblx0aWYgKERFVikge1xuXHRcdGNvbnN0IGVycm9yID0gbmV3IEVycm9yKGBiaW5kX2ludmFsaWRfY2hlY2tib3hfdmFsdWVcXG5Vc2luZyBcXGBiaW5kOnZhbHVlXFxgIHRvZ2V0aGVyIHdpdGggYSBjaGVja2JveCBpbnB1dCBpcyBub3QgYWxsb3dlZC4gVXNlIFxcYGJpbmQ6Y2hlY2tlZFxcYCBpbnN0ZWFkXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvYmluZF9pbnZhbGlkX2NoZWNrYm94X3ZhbHVlYCk7XG5cblx0XHRlcnJvci5uYW1lID0gJ1N2ZWx0ZSBlcnJvcic7XG5cdFx0dGhyb3cgZXJyb3I7XG5cdH0gZWxzZSB7XG5cdFx0dGhyb3cgbmV3IEVycm9yKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9iaW5kX2ludmFsaWRfY2hlY2tib3hfdmFsdWVgKTtcblx0fVxufVxuXG4vKipcbiAqIENvbXBvbmVudCAlY29tcG9uZW50JSBoYXMgYW4gZXhwb3J0IG5hbWVkIGAla2V5JWAgdGhhdCBhIGNvbnN1bWVyIGNvbXBvbmVudCBpcyB0cnlpbmcgdG8gYWNjZXNzIHVzaW5nIGBiaW5kOiVrZXklYCwgd2hpY2ggaXMgZGlzYWxsb3dlZC4gSW5zdGVhZCwgdXNlIGBiaW5kOnRoaXNgIChlLmcuIGA8JW5hbWUlIGJpbmQ6dGhpcz17Y29tcG9uZW50fSAvPmApIGFuZCB0aGVuIGFjY2VzcyB0aGUgcHJvcGVydHkgb24gdGhlIGJvdW5kIGNvbXBvbmVudCBpbnN0YW5jZSAoZS5nLiBgY29tcG9uZW50LiVrZXklYClcbiAqIEBwYXJhbSB7c3RyaW5nfSBjb21wb25lbnRcbiAqIEBwYXJhbSB7c3RyaW5nfSBrZXlcbiAqIEBwYXJhbSB7c3RyaW5nfSBuYW1lXG4gKiBAcmV0dXJucyB7bmV2ZXJ9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBiaW5kX2ludmFsaWRfZXhwb3J0KGNvbXBvbmVudCwga2V5LCBuYW1lKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zdCBlcnJvciA9IG5ldyBFcnJvcihgYmluZF9pbnZhbGlkX2V4cG9ydFxcbkNvbXBvbmVudCAke2NvbXBvbmVudH0gaGFzIGFuIGV4cG9ydCBuYW1lZCBcXGAke2tleX1cXGAgdGhhdCBhIGNvbnN1bWVyIGNvbXBvbmVudCBpcyB0cnlpbmcgdG8gYWNjZXNzIHVzaW5nIFxcYGJpbmQ6JHtrZXl9XFxgLCB3aGljaCBpcyBkaXNhbGxvd2VkLiBJbnN0ZWFkLCB1c2UgXFxgYmluZDp0aGlzXFxgIChlLmcuIFxcYDwke25hbWV9IGJpbmQ6dGhpcz17Y29tcG9uZW50fSAvPlxcYCkgYW5kIHRoZW4gYWNjZXNzIHRoZSBwcm9wZXJ0eSBvbiB0aGUgYm91bmQgY29tcG9uZW50IGluc3RhbmNlIChlLmcuIFxcYGNvbXBvbmVudC4ke2tleX1cXGApXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvYmluZF9pbnZhbGlkX2V4cG9ydGApO1xuXG5cdFx0ZXJyb3IubmFtZSA9ICdTdmVsdGUgZXJyb3InO1xuXHRcdHRocm93IGVycm9yO1xuXHR9IGVsc2Uge1xuXHRcdHRocm93IG5ldyBFcnJvcihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvYmluZF9pbnZhbGlkX2V4cG9ydGApO1xuXHR9XG59XG5cbi8qKlxuICogQSBjb21wb25lbnQgaXMgYXR0ZW1wdGluZyB0byBiaW5kIHRvIGEgbm9uLWJpbmRhYmxlIHByb3BlcnR5IGAla2V5JWAgYmVsb25naW5nIHRvICVjb21wb25lbnQlIChpLmUuIGA8JW5hbWUlIGJpbmQ6JWtleSU9ey4uLn0+YCkuIFRvIG1hcmsgYSBwcm9wZXJ0eSBhcyBiaW5kYWJsZTogYGxldCB7ICVrZXklID0gJGJpbmRhYmxlKCkgfSA9ICRwcm9wcygpYFxuICogQHBhcmFtIHtzdHJpbmd9IGtleVxuICogQHBhcmFtIHtzdHJpbmd9IGNvbXBvbmVudFxuICogQHBhcmFtIHtzdHJpbmd9IG5hbWVcbiAqIEByZXR1cm5zIHtuZXZlcn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGJpbmRfbm90X2JpbmRhYmxlKGtleSwgY29tcG9uZW50LCBuYW1lKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zdCBlcnJvciA9IG5ldyBFcnJvcihgYmluZF9ub3RfYmluZGFibGVcXG5BIGNvbXBvbmVudCBpcyBhdHRlbXB0aW5nIHRvIGJpbmQgdG8gYSBub24tYmluZGFibGUgcHJvcGVydHkgXFxgJHtrZXl9XFxgIGJlbG9uZ2luZyB0byAke2NvbXBvbmVudH0gKGkuZS4gXFxgPCR7bmFtZX0gYmluZDoke2tleX09ey4uLn0+XFxgKS4gVG8gbWFyayBhIHByb3BlcnR5IGFzIGJpbmRhYmxlOiBcXGBsZXQgeyAke2tleX0gPSAkYmluZGFibGUoKSB9ID0gJHByb3BzKClcXGBcXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9iaW5kX25vdF9iaW5kYWJsZWApO1xuXG5cdFx0ZXJyb3IubmFtZSA9ICdTdmVsdGUgZXJyb3InO1xuXHRcdHRocm93IGVycm9yO1xuXHR9IGVsc2Uge1xuXHRcdHRocm93IG5ldyBFcnJvcihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvYmluZF9ub3RfYmluZGFibGVgKTtcblx0fVxufVxuXG4vKipcbiAqICVwYXJlbnQlIGNhbGxlZCBgJW1ldGhvZCVgIG9uIGFuIGluc3RhbmNlIG9mICVjb21wb25lbnQlLCB3aGljaCBpcyBubyBsb25nZXIgdmFsaWQgaW4gU3ZlbHRlIDVcbiAqIEBwYXJhbSB7c3RyaW5nfSBwYXJlbnRcbiAqIEBwYXJhbSB7c3RyaW5nfSBtZXRob2RcbiAqIEBwYXJhbSB7c3RyaW5nfSBjb21wb25lbnRcbiAqIEByZXR1cm5zIHtuZXZlcn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGNvbXBvbmVudF9hcGlfY2hhbmdlZChwYXJlbnQsIG1ldGhvZCwgY29tcG9uZW50KSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zdCBlcnJvciA9IG5ldyBFcnJvcihgY29tcG9uZW50X2FwaV9jaGFuZ2VkXFxuJHtwYXJlbnR9IGNhbGxlZCBcXGAke21ldGhvZH1cXGAgb24gYW4gaW5zdGFuY2Ugb2YgJHtjb21wb25lbnR9LCB3aGljaCBpcyBubyBsb25nZXIgdmFsaWQgaW4gU3ZlbHRlIDVcXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9jb21wb25lbnRfYXBpX2NoYW5nZWRgKTtcblxuXHRcdGVycm9yLm5hbWUgPSAnU3ZlbHRlIGVycm9yJztcblx0XHR0aHJvdyBlcnJvcjtcblx0fSBlbHNlIHtcblx0XHR0aHJvdyBuZXcgRXJyb3IoYGh0dHBzOi8vc3ZlbHRlLmRldi9lL2NvbXBvbmVudF9hcGlfY2hhbmdlZGApO1xuXHR9XG59XG5cbi8qKlxuICogQXR0ZW1wdGVkIHRvIGluc3RhbnRpYXRlICVjb21wb25lbnQlIHdpdGggYG5ldyAlbmFtZSVgLCB3aGljaCBpcyBubyBsb25nZXIgdmFsaWQgaW4gU3ZlbHRlIDUuIElmIHRoaXMgY29tcG9uZW50IGlzIG5vdCB1bmRlciB5b3VyIGNvbnRyb2wsIHNldCB0aGUgYGNvbXBhdGliaWxpdHkuY29tcG9uZW50QXBpYCBjb21waWxlciBvcHRpb24gdG8gYDRgIHRvIGtlZXAgaXQgd29ya2luZy5cbiAqIEBwYXJhbSB7c3RyaW5nfSBjb21wb25lbnRcbiAqIEBwYXJhbSB7c3RyaW5nfSBuYW1lXG4gKiBAcmV0dXJucyB7bmV2ZXJ9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjb21wb25lbnRfYXBpX2ludmFsaWRfbmV3KGNvbXBvbmVudCwgbmFtZSkge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc3QgZXJyb3IgPSBuZXcgRXJyb3IoYGNvbXBvbmVudF9hcGlfaW52YWxpZF9uZXdcXG5BdHRlbXB0ZWQgdG8gaW5zdGFudGlhdGUgJHtjb21wb25lbnR9IHdpdGggXFxgbmV3ICR7bmFtZX1cXGAsIHdoaWNoIGlzIG5vIGxvbmdlciB2YWxpZCBpbiBTdmVsdGUgNS4gSWYgdGhpcyBjb21wb25lbnQgaXMgbm90IHVuZGVyIHlvdXIgY29udHJvbCwgc2V0IHRoZSBcXGBjb21wYXRpYmlsaXR5LmNvbXBvbmVudEFwaVxcYCBjb21waWxlciBvcHRpb24gdG8gXFxgNFxcYCB0byBrZWVwIGl0IHdvcmtpbmcuXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvY29tcG9uZW50X2FwaV9pbnZhbGlkX25ld2ApO1xuXG5cdFx0ZXJyb3IubmFtZSA9ICdTdmVsdGUgZXJyb3InO1xuXHRcdHRocm93IGVycm9yO1xuXHR9IGVsc2Uge1xuXHRcdHRocm93IG5ldyBFcnJvcihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvY29tcG9uZW50X2FwaV9pbnZhbGlkX25ld2ApO1xuXHR9XG59XG5cbi8qKlxuICogQSBkZXJpdmVkIHZhbHVlIGNhbm5vdCByZWZlcmVuY2UgaXRzZWxmIHJlY3Vyc2l2ZWx5XG4gKiBAcmV0dXJucyB7bmV2ZXJ9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBkZXJpdmVkX3JlZmVyZW5jZXNfc2VsZigpIHtcblx0aWYgKERFVikge1xuXHRcdGNvbnN0IGVycm9yID0gbmV3IEVycm9yKGBkZXJpdmVkX3JlZmVyZW5jZXNfc2VsZlxcbkEgZGVyaXZlZCB2YWx1ZSBjYW5ub3QgcmVmZXJlbmNlIGl0c2VsZiByZWN1cnNpdmVseVxcbmh0dHBzOi8vc3ZlbHRlLmRldi9lL2Rlcml2ZWRfcmVmZXJlbmNlc19zZWxmYCk7XG5cblx0XHRlcnJvci5uYW1lID0gJ1N2ZWx0ZSBlcnJvcic7XG5cdFx0dGhyb3cgZXJyb3I7XG5cdH0gZWxzZSB7XG5cdFx0dGhyb3cgbmV3IEVycm9yKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9kZXJpdmVkX3JlZmVyZW5jZXNfc2VsZmApO1xuXHR9XG59XG5cbi8qKlxuICogS2V5ZWQgZWFjaCBibG9jayBoYXMgZHVwbGljYXRlIGtleSBgJXZhbHVlJWAgYXQgaW5kZXhlcyAlYSUgYW5kICViJVxuICogQHBhcmFtIHtzdHJpbmd9IGFcbiAqIEBwYXJhbSB7c3RyaW5nfSBiXG4gKiBAcGFyYW0ge3N0cmluZyB8IHVuZGVmaW5lZCB8IG51bGx9IFt2YWx1ZV1cbiAqIEByZXR1cm5zIHtuZXZlcn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGVhY2hfa2V5X2R1cGxpY2F0ZShhLCBiLCB2YWx1ZSkge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc3QgZXJyb3IgPSBuZXcgRXJyb3IoYGVhY2hfa2V5X2R1cGxpY2F0ZVxcbiR7dmFsdWUgPyBgS2V5ZWQgZWFjaCBibG9jayBoYXMgZHVwbGljYXRlIGtleSBcXGAke3ZhbHVlfVxcYCBhdCBpbmRleGVzICR7YX0gYW5kICR7Yn1gIDogYEtleWVkIGVhY2ggYmxvY2sgaGFzIGR1cGxpY2F0ZSBrZXkgYXQgaW5kZXhlcyAke2F9IGFuZCAke2J9YH1cXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9lYWNoX2tleV9kdXBsaWNhdGVgKTtcblxuXHRcdGVycm9yLm5hbWUgPSAnU3ZlbHRlIGVycm9yJztcblx0XHR0aHJvdyBlcnJvcjtcblx0fSBlbHNlIHtcblx0XHR0aHJvdyBuZXcgRXJyb3IoYGh0dHBzOi8vc3ZlbHRlLmRldi9lL2VhY2hfa2V5X2R1cGxpY2F0ZWApO1xuXHR9XG59XG5cbi8qKlxuICogYCVydW5lJWAgY2Fubm90IGJlIHVzZWQgaW5zaWRlIGFuIGVmZmVjdCBjbGVhbnVwIGZ1bmN0aW9uXG4gKiBAcGFyYW0ge3N0cmluZ30gcnVuZVxuICogQHJldHVybnMge25ldmVyfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZWZmZWN0X2luX3RlYXJkb3duKHJ1bmUpIHtcblx0aWYgKERFVikge1xuXHRcdGNvbnN0IGVycm9yID0gbmV3IEVycm9yKGBlZmZlY3RfaW5fdGVhcmRvd25cXG5cXGAke3J1bmV9XFxgIGNhbm5vdCBiZSB1c2VkIGluc2lkZSBhbiBlZmZlY3QgY2xlYW51cCBmdW5jdGlvblxcbmh0dHBzOi8vc3ZlbHRlLmRldi9lL2VmZmVjdF9pbl90ZWFyZG93bmApO1xuXG5cdFx0ZXJyb3IubmFtZSA9ICdTdmVsdGUgZXJyb3InO1xuXHRcdHRocm93IGVycm9yO1xuXHR9IGVsc2Uge1xuXHRcdHRocm93IG5ldyBFcnJvcihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvZWZmZWN0X2luX3RlYXJkb3duYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBFZmZlY3QgY2Fubm90IGJlIGNyZWF0ZWQgaW5zaWRlIGEgYCRkZXJpdmVkYCB2YWx1ZSB0aGF0IHdhcyBub3QgaXRzZWxmIGNyZWF0ZWQgaW5zaWRlIGFuIGVmZmVjdFxuICogQHJldHVybnMge25ldmVyfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZWZmZWN0X2luX3Vub3duZWRfZGVyaXZlZCgpIHtcblx0aWYgKERFVikge1xuXHRcdGNvbnN0IGVycm9yID0gbmV3IEVycm9yKGBlZmZlY3RfaW5fdW5vd25lZF9kZXJpdmVkXFxuRWZmZWN0IGNhbm5vdCBiZSBjcmVhdGVkIGluc2lkZSBhIFxcYCRkZXJpdmVkXFxgIHZhbHVlIHRoYXQgd2FzIG5vdCBpdHNlbGYgY3JlYXRlZCBpbnNpZGUgYW4gZWZmZWN0XFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvZWZmZWN0X2luX3Vub3duZWRfZGVyaXZlZGApO1xuXG5cdFx0ZXJyb3IubmFtZSA9ICdTdmVsdGUgZXJyb3InO1xuXHRcdHRocm93IGVycm9yO1xuXHR9IGVsc2Uge1xuXHRcdHRocm93IG5ldyBFcnJvcihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvZWZmZWN0X2luX3Vub3duZWRfZGVyaXZlZGApO1xuXHR9XG59XG5cbi8qKlxuICogYCVydW5lJWAgY2FuIG9ubHkgYmUgdXNlZCBpbnNpZGUgYW4gZWZmZWN0IChlLmcuIGR1cmluZyBjb21wb25lbnQgaW5pdGlhbGlzYXRpb24pXG4gKiBAcGFyYW0ge3N0cmluZ30gcnVuZVxuICogQHJldHVybnMge25ldmVyfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZWZmZWN0X29ycGhhbihydW5lKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zdCBlcnJvciA9IG5ldyBFcnJvcihgZWZmZWN0X29ycGhhblxcblxcYCR7cnVuZX1cXGAgY2FuIG9ubHkgYmUgdXNlZCBpbnNpZGUgYW4gZWZmZWN0IChlLmcuIGR1cmluZyBjb21wb25lbnQgaW5pdGlhbGlzYXRpb24pXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvZWZmZWN0X29ycGhhbmApO1xuXG5cdFx0ZXJyb3IubmFtZSA9ICdTdmVsdGUgZXJyb3InO1xuXHRcdHRocm93IGVycm9yO1xuXHR9IGVsc2Uge1xuXHRcdHRocm93IG5ldyBFcnJvcihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvZWZmZWN0X29ycGhhbmApO1xuXHR9XG59XG5cbi8qKlxuICogTWF4aW11bSB1cGRhdGUgZGVwdGggZXhjZWVkZWQuIFRoaXMgY2FuIGhhcHBlbiB3aGVuIGEgcmVhY3RpdmUgYmxvY2sgb3IgZWZmZWN0IHJlcGVhdGVkbHkgc2V0cyBhIG5ldyB2YWx1ZS4gU3ZlbHRlIGxpbWl0cyB0aGUgbnVtYmVyIG9mIG5lc3RlZCB1cGRhdGVzIHRvIHByZXZlbnQgaW5maW5pdGUgbG9vcHNcbiAqIEByZXR1cm5zIHtuZXZlcn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGVmZmVjdF91cGRhdGVfZGVwdGhfZXhjZWVkZWQoKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zdCBlcnJvciA9IG5ldyBFcnJvcihgZWZmZWN0X3VwZGF0ZV9kZXB0aF9leGNlZWRlZFxcbk1heGltdW0gdXBkYXRlIGRlcHRoIGV4Y2VlZGVkLiBUaGlzIGNhbiBoYXBwZW4gd2hlbiBhIHJlYWN0aXZlIGJsb2NrIG9yIGVmZmVjdCByZXBlYXRlZGx5IHNldHMgYSBuZXcgdmFsdWUuIFN2ZWx0ZSBsaW1pdHMgdGhlIG51bWJlciBvZiBuZXN0ZWQgdXBkYXRlcyB0byBwcmV2ZW50IGluZmluaXRlIGxvb3BzXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvZWZmZWN0X3VwZGF0ZV9kZXB0aF9leGNlZWRlZGApO1xuXG5cdFx0ZXJyb3IubmFtZSA9ICdTdmVsdGUgZXJyb3InO1xuXHRcdHRocm93IGVycm9yO1xuXHR9IGVsc2Uge1xuXHRcdHRocm93IG5ldyBFcnJvcihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvZWZmZWN0X3VwZGF0ZV9kZXB0aF9leGNlZWRlZGApO1xuXHR9XG59XG5cbi8qKlxuICogRmFpbGVkIHRvIGh5ZHJhdGUgdGhlIGFwcGxpY2F0aW9uXG4gKiBAcmV0dXJucyB7bmV2ZXJ9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBoeWRyYXRpb25fZmFpbGVkKCkge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc3QgZXJyb3IgPSBuZXcgRXJyb3IoYGh5ZHJhdGlvbl9mYWlsZWRcXG5GYWlsZWQgdG8gaHlkcmF0ZSB0aGUgYXBwbGljYXRpb25cXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9oeWRyYXRpb25fZmFpbGVkYCk7XG5cblx0XHRlcnJvci5uYW1lID0gJ1N2ZWx0ZSBlcnJvcic7XG5cdFx0dGhyb3cgZXJyb3I7XG5cdH0gZWxzZSB7XG5cdFx0dGhyb3cgbmV3IEVycm9yKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9oeWRyYXRpb25fZmFpbGVkYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBDb3VsZCBub3QgYHtAcmVuZGVyfWAgc25pcHBldCBkdWUgdG8gdGhlIGV4cHJlc3Npb24gYmVpbmcgYG51bGxgIG9yIGB1bmRlZmluZWRgLiBDb25zaWRlciB1c2luZyBvcHRpb25hbCBjaGFpbmluZyBge0ByZW5kZXIgc25pcHBldD8uKCl9YFxuICogQHJldHVybnMge25ldmVyfVxuICovXG5leHBvcnQgZnVuY3Rpb24gaW52YWxpZF9zbmlwcGV0KCkge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc3QgZXJyb3IgPSBuZXcgRXJyb3IoYGludmFsaWRfc25pcHBldFxcbkNvdWxkIG5vdCBcXGB7QHJlbmRlcn1cXGAgc25pcHBldCBkdWUgdG8gdGhlIGV4cHJlc3Npb24gYmVpbmcgXFxgbnVsbFxcYCBvciBcXGB1bmRlZmluZWRcXGAuIENvbnNpZGVyIHVzaW5nIG9wdGlvbmFsIGNoYWluaW5nIFxcYHtAcmVuZGVyIHNuaXBwZXQ/LigpfVxcYFxcbmh0dHBzOi8vc3ZlbHRlLmRldi9lL2ludmFsaWRfc25pcHBldGApO1xuXG5cdFx0ZXJyb3IubmFtZSA9ICdTdmVsdGUgZXJyb3InO1xuXHRcdHRocm93IGVycm9yO1xuXHR9IGVsc2Uge1xuXHRcdHRocm93IG5ldyBFcnJvcihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvaW52YWxpZF9zbmlwcGV0YCk7XG5cdH1cbn1cblxuLyoqXG4gKiBgJW5hbWUlKC4uLilgIGNhbm5vdCBiZSB1c2VkIGluIHJ1bmVzIG1vZGVcbiAqIEBwYXJhbSB7c3RyaW5nfSBuYW1lXG4gKiBAcmV0dXJucyB7bmV2ZXJ9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBsaWZlY3ljbGVfbGVnYWN5X29ubHkobmFtZSkge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc3QgZXJyb3IgPSBuZXcgRXJyb3IoYGxpZmVjeWNsZV9sZWdhY3lfb25seVxcblxcYCR7bmFtZX0oLi4uKVxcYCBjYW5ub3QgYmUgdXNlZCBpbiBydW5lcyBtb2RlXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvbGlmZWN5Y2xlX2xlZ2FjeV9vbmx5YCk7XG5cblx0XHRlcnJvci5uYW1lID0gJ1N2ZWx0ZSBlcnJvcic7XG5cdFx0dGhyb3cgZXJyb3I7XG5cdH0gZWxzZSB7XG5cdFx0dGhyb3cgbmV3IEVycm9yKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9saWZlY3ljbGVfbGVnYWN5X29ubHlgKTtcblx0fVxufVxuXG4vKipcbiAqIENhbm5vdCBkbyBgYmluZDola2V5JT17dW5kZWZpbmVkfWAgd2hlbiBgJWtleSVgIGhhcyBhIGZhbGxiYWNrIHZhbHVlXG4gKiBAcGFyYW0ge3N0cmluZ30ga2V5XG4gKiBAcmV0dXJucyB7bmV2ZXJ9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBwcm9wc19pbnZhbGlkX3ZhbHVlKGtleSkge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc3QgZXJyb3IgPSBuZXcgRXJyb3IoYHByb3BzX2ludmFsaWRfdmFsdWVcXG5DYW5ub3QgZG8gXFxgYmluZDoke2tleX09e3VuZGVmaW5lZH1cXGAgd2hlbiBcXGAke2tleX1cXGAgaGFzIGEgZmFsbGJhY2sgdmFsdWVcXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9wcm9wc19pbnZhbGlkX3ZhbHVlYCk7XG5cblx0XHRlcnJvci5uYW1lID0gJ1N2ZWx0ZSBlcnJvcic7XG5cdFx0dGhyb3cgZXJyb3I7XG5cdH0gZWxzZSB7XG5cdFx0dGhyb3cgbmV3IEVycm9yKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9wcm9wc19pbnZhbGlkX3ZhbHVlYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBSZXN0IGVsZW1lbnQgcHJvcGVydGllcyBvZiBgJHByb3BzKClgIHN1Y2ggYXMgYCVwcm9wZXJ0eSVgIGFyZSByZWFkb25seVxuICogQHBhcmFtIHtzdHJpbmd9IHByb3BlcnR5XG4gKiBAcmV0dXJucyB7bmV2ZXJ9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBwcm9wc19yZXN0X3JlYWRvbmx5KHByb3BlcnR5KSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zdCBlcnJvciA9IG5ldyBFcnJvcihgcHJvcHNfcmVzdF9yZWFkb25seVxcblJlc3QgZWxlbWVudCBwcm9wZXJ0aWVzIG9mIFxcYCRwcm9wcygpXFxgIHN1Y2ggYXMgXFxgJHtwcm9wZXJ0eX1cXGAgYXJlIHJlYWRvbmx5XFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvcHJvcHNfcmVzdF9yZWFkb25seWApO1xuXG5cdFx0ZXJyb3IubmFtZSA9ICdTdmVsdGUgZXJyb3InO1xuXHRcdHRocm93IGVycm9yO1xuXHR9IGVsc2Uge1xuXHRcdHRocm93IG5ldyBFcnJvcihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvcHJvcHNfcmVzdF9yZWFkb25seWApO1xuXHR9XG59XG5cbi8qKlxuICogVGhlIGAlcnVuZSVgIHJ1bmUgaXMgb25seSBhdmFpbGFibGUgaW5zaWRlIGAuc3ZlbHRlYCBhbmQgYC5zdmVsdGUuanMvdHNgIGZpbGVzXG4gKiBAcGFyYW0ge3N0cmluZ30gcnVuZVxuICogQHJldHVybnMge25ldmVyfVxuICovXG5leHBvcnQgZnVuY3Rpb24gcnVuZV9vdXRzaWRlX3N2ZWx0ZShydW5lKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zdCBlcnJvciA9IG5ldyBFcnJvcihgcnVuZV9vdXRzaWRlX3N2ZWx0ZVxcblRoZSBcXGAke3J1bmV9XFxgIHJ1bmUgaXMgb25seSBhdmFpbGFibGUgaW5zaWRlIFxcYC5zdmVsdGVcXGAgYW5kIFxcYC5zdmVsdGUuanMvdHNcXGAgZmlsZXNcXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9ydW5lX291dHNpZGVfc3ZlbHRlYCk7XG5cblx0XHRlcnJvci5uYW1lID0gJ1N2ZWx0ZSBlcnJvcic7XG5cdFx0dGhyb3cgZXJyb3I7XG5cdH0gZWxzZSB7XG5cdFx0dGhyb3cgbmV3IEVycm9yKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9ydW5lX291dHNpZGVfc3ZlbHRlYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBQcm9wZXJ0eSBkZXNjcmlwdG9ycyBkZWZpbmVkIG9uIGAkc3RhdGVgIG9iamVjdHMgbXVzdCBjb250YWluIGB2YWx1ZWAgYW5kIGFsd2F5cyBiZSBgZW51bWVyYWJsZWAsIGBjb25maWd1cmFibGVgIGFuZCBgd3JpdGFibGVgLlxuICogQHJldHVybnMge25ldmVyfVxuICovXG5leHBvcnQgZnVuY3Rpb24gc3RhdGVfZGVzY3JpcHRvcnNfZml4ZWQoKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zdCBlcnJvciA9IG5ldyBFcnJvcihgc3RhdGVfZGVzY3JpcHRvcnNfZml4ZWRcXG5Qcm9wZXJ0eSBkZXNjcmlwdG9ycyBkZWZpbmVkIG9uIFxcYCRzdGF0ZVxcYCBvYmplY3RzIG11c3QgY29udGFpbiBcXGB2YWx1ZVxcYCBhbmQgYWx3YXlzIGJlIFxcYGVudW1lcmFibGVcXGAsIFxcYGNvbmZpZ3VyYWJsZVxcYCBhbmQgXFxgd3JpdGFibGVcXGAuXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2Uvc3RhdGVfZGVzY3JpcHRvcnNfZml4ZWRgKTtcblxuXHRcdGVycm9yLm5hbWUgPSAnU3ZlbHRlIGVycm9yJztcblx0XHR0aHJvdyBlcnJvcjtcblx0fSBlbHNlIHtcblx0XHR0aHJvdyBuZXcgRXJyb3IoYGh0dHBzOi8vc3ZlbHRlLmRldi9lL3N0YXRlX2Rlc2NyaXB0b3JzX2ZpeGVkYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBDYW5ub3Qgc2V0IHByb3RvdHlwZSBvZiBgJHN0YXRlYCBvYmplY3RcbiAqIEByZXR1cm5zIHtuZXZlcn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHN0YXRlX3Byb3RvdHlwZV9maXhlZCgpIHtcblx0aWYgKERFVikge1xuXHRcdGNvbnN0IGVycm9yID0gbmV3IEVycm9yKGBzdGF0ZV9wcm90b3R5cGVfZml4ZWRcXG5DYW5ub3Qgc2V0IHByb3RvdHlwZSBvZiBcXGAkc3RhdGVcXGAgb2JqZWN0XFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2Uvc3RhdGVfcHJvdG90eXBlX2ZpeGVkYCk7XG5cblx0XHRlcnJvci5uYW1lID0gJ1N2ZWx0ZSBlcnJvcic7XG5cdFx0dGhyb3cgZXJyb3I7XG5cdH0gZWxzZSB7XG5cdFx0dGhyb3cgbmV3IEVycm9yKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9zdGF0ZV9wcm90b3R5cGVfZml4ZWRgKTtcblx0fVxufVxuXG4vKipcbiAqIFJlYWRpbmcgc3RhdGUgdGhhdCB3YXMgY3JlYXRlZCBpbnNpZGUgdGhlIHNhbWUgZGVyaXZlZCBpcyBmb3JiaWRkZW4uIENvbnNpZGVyIHVzaW5nIGB1bnRyYWNrYCB0byByZWFkIGxvY2FsbHkgY3JlYXRlZCBzdGF0ZVxuICogQHJldHVybnMge25ldmVyfVxuICovXG5leHBvcnQgZnVuY3Rpb24gc3RhdGVfdW5zYWZlX2xvY2FsX3JlYWQoKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zdCBlcnJvciA9IG5ldyBFcnJvcihgc3RhdGVfdW5zYWZlX2xvY2FsX3JlYWRcXG5SZWFkaW5nIHN0YXRlIHRoYXQgd2FzIGNyZWF0ZWQgaW5zaWRlIHRoZSBzYW1lIGRlcml2ZWQgaXMgZm9yYmlkZGVuLiBDb25zaWRlciB1c2luZyBcXGB1bnRyYWNrXFxgIHRvIHJlYWQgbG9jYWxseSBjcmVhdGVkIHN0YXRlXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2Uvc3RhdGVfdW5zYWZlX2xvY2FsX3JlYWRgKTtcblxuXHRcdGVycm9yLm5hbWUgPSAnU3ZlbHRlIGVycm9yJztcblx0XHR0aHJvdyBlcnJvcjtcblx0fSBlbHNlIHtcblx0XHR0aHJvdyBuZXcgRXJyb3IoYGh0dHBzOi8vc3ZlbHRlLmRldi9lL3N0YXRlX3Vuc2FmZV9sb2NhbF9yZWFkYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBVcGRhdGluZyBzdGF0ZSBpbnNpZGUgYSBkZXJpdmVkIG9yIGEgdGVtcGxhdGUgZXhwcmVzc2lvbiBpcyBmb3JiaWRkZW4uIElmIHRoZSB2YWx1ZSBzaG91bGQgbm90IGJlIHJlYWN0aXZlLCBkZWNsYXJlIGl0IHdpdGhvdXQgYCRzdGF0ZWBcbiAqIEByZXR1cm5zIHtuZXZlcn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHN0YXRlX3Vuc2FmZV9tdXRhdGlvbigpIHtcblx0aWYgKERFVikge1xuXHRcdGNvbnN0IGVycm9yID0gbmV3IEVycm9yKGBzdGF0ZV91bnNhZmVfbXV0YXRpb25cXG5VcGRhdGluZyBzdGF0ZSBpbnNpZGUgYSBkZXJpdmVkIG9yIGEgdGVtcGxhdGUgZXhwcmVzc2lvbiBpcyBmb3JiaWRkZW4uIElmIHRoZSB2YWx1ZSBzaG91bGQgbm90IGJlIHJlYWN0aXZlLCBkZWNsYXJlIGl0IHdpdGhvdXQgXFxgJHN0YXRlXFxgXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2Uvc3RhdGVfdW5zYWZlX211dGF0aW9uYCk7XG5cblx0XHRlcnJvci5uYW1lID0gJ1N2ZWx0ZSBlcnJvcic7XG5cdFx0dGhyb3cgZXJyb3I7XG5cdH0gZWxzZSB7XG5cdFx0dGhyb3cgbmV3IEVycm9yKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9zdGF0ZV91bnNhZmVfbXV0YXRpb25gKTtcblx0fVxufSIsICJleHBvcnQgbGV0IGxlZ2FjeV9tb2RlX2ZsYWcgPSBmYWxzZTtcbmV4cG9ydCBsZXQgdHJhY2luZ19tb2RlX2ZsYWcgPSBmYWxzZTtcblxuZXhwb3J0IGZ1bmN0aW9uIGVuYWJsZV9sZWdhY3lfbW9kZV9mbGFnKCkge1xuXHRsZWdhY3lfbW9kZV9mbGFnID0gdHJ1ZTtcbn1cblxuZXhwb3J0IGZ1bmN0aW9uIGVuYWJsZV90cmFjaW5nX21vZGVfZmxhZygpIHtcblx0dHJhY2luZ19tb2RlX2ZsYWcgPSB0cnVlO1xufVxuIiwgIi8qKiBAaW1wb3J0IHsgRGVyaXZlZCwgUmVhY3Rpb24sIFNpZ25hbCwgVmFsdWUgfSBmcm9tICcjY2xpZW50JyAqL1xuaW1wb3J0IHsgVU5JTklUSUFMSVpFRCB9IGZyb20gJy4uLy4uLy4uL2NvbnN0YW50cy5qcyc7XG5pbXBvcnQgeyBzbmFwc2hvdCB9IGZyb20gJy4uLy4uL3NoYXJlZC9jbG9uZS5qcyc7XG5pbXBvcnQgeyBkZWZpbmVfcHJvcGVydHkgfSBmcm9tICcuLi8uLi9zaGFyZWQvdXRpbHMuanMnO1xuaW1wb3J0IHsgREVSSVZFRCwgU1RBVEVfU1lNQk9MIH0gZnJvbSAnLi4vY29uc3RhbnRzLmpzJztcbmltcG9ydCB7IGVmZmVjdF90cmFja2luZyB9IGZyb20gJy4uL3JlYWN0aXZpdHkvZWZmZWN0cy5qcyc7XG5pbXBvcnQgeyBhY3RpdmVfcmVhY3Rpb24sIGNhcHR1cmVkX3NpZ25hbHMsIHNldF9jYXB0dXJlZF9zaWduYWxzLCB1bnRyYWNrIH0gZnJvbSAnLi4vcnVudGltZS5qcyc7XG5cbi8qKiBAdHlwZSB7IGFueSB9ICovXG5leHBvcnQgbGV0IHRyYWNpbmdfZXhwcmVzc2lvbnMgPSBudWxsO1xuXG4vKipcbiAqIEBwYXJhbSB7IFZhbHVlIH0gc2lnbmFsXG4gKiBAcGFyYW0geyB7IHJlYWQ6IEVycm9yW10gfSB9IFtlbnRyeV1cbiAqL1xuZnVuY3Rpb24gbG9nX2VudHJ5KHNpZ25hbCwgZW50cnkpIHtcblx0Y29uc3QgZGVidWcgPSBzaWduYWwuZGVidWc7XG5cdGNvbnN0IHZhbHVlID0gc2lnbmFsLnRyYWNlX25lZWRfaW5jcmVhc2UgPyBzaWduYWwudHJhY2VfdiA6IHNpZ25hbC52O1xuXG5cdGlmICh2YWx1ZSA9PT0gVU5JTklUSUFMSVpFRCkge1xuXHRcdHJldHVybjtcblx0fVxuXG5cdGlmIChkZWJ1Zykge1xuXHRcdHZhciBwcmV2aW91c19jYXB0dXJlZF9zaWduYWxzID0gY2FwdHVyZWRfc2lnbmFscztcblx0XHR2YXIgY2FwdHVyZWQgPSBuZXcgU2V0KCk7XG5cdFx0c2V0X2NhcHR1cmVkX3NpZ25hbHMoY2FwdHVyZWQpO1xuXHRcdHRyeSB7XG5cdFx0XHR1bnRyYWNrKCgpID0+IHtcblx0XHRcdFx0ZGVidWcoKTtcblx0XHRcdH0pO1xuXHRcdH0gZmluYWxseSB7XG5cdFx0XHRzZXRfY2FwdHVyZWRfc2lnbmFscyhwcmV2aW91c19jYXB0dXJlZF9zaWduYWxzKTtcblx0XHR9XG5cdFx0aWYgKGNhcHR1cmVkLnNpemUgPiAwKSB7XG5cdFx0XHRmb3IgKGNvbnN0IGRlcCBvZiBjYXB0dXJlZCkge1xuXHRcdFx0XHRsb2dfZW50cnkoZGVwKTtcblx0XHRcdH1cblx0XHRcdHJldHVybjtcblx0XHR9XG5cdH1cblxuXHRjb25zdCB0eXBlID0gKHNpZ25hbC5mICYgREVSSVZFRCkgIT09IDAgPyAnJGRlcml2ZWQnIDogJyRzdGF0ZSc7XG5cdGNvbnN0IGN1cnJlbnRfcmVhY3Rpb24gPSAvKiogQHR5cGUge1JlYWN0aW9ufSAqLyAoYWN0aXZlX3JlYWN0aW9uKTtcblx0Y29uc3QgZGlydHkgPSBzaWduYWwud3YgPiBjdXJyZW50X3JlYWN0aW9uLnd2IHx8IGN1cnJlbnRfcmVhY3Rpb24ud3YgPT09IDA7XG5cblx0Ly8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG5vLWNvbnNvbGVcblx0Y29uc29sZS5ncm91cENvbGxhcHNlZChcblx0XHRgJWMke3R5cGV9YCxcblx0XHRkaXJ0eSA/ICdjb2xvcjogQ29ybmZsb3dlckJsdWU7IGZvbnQtd2VpZ2h0OiBib2xkJyA6ICdjb2xvcjogZ3JleTsgZm9udC13ZWlnaHQ6IGJvbGQnLFxuXHRcdHR5cGVvZiB2YWx1ZSA9PT0gJ29iamVjdCcgJiYgdmFsdWUgIT09IG51bGwgJiYgU1RBVEVfU1lNQk9MIGluIHZhbHVlXG5cdFx0XHQ/IHNuYXBzaG90KHZhbHVlLCB0cnVlKVxuXHRcdFx0OiB2YWx1ZVxuXHQpO1xuXG5cdGlmICh0eXBlID09PSAnJGRlcml2ZWQnKSB7XG5cdFx0Y29uc3QgZGVwcyA9IG5ldyBTZXQoLyoqIEB0eXBlIHtEZXJpdmVkfSAqLyAoc2lnbmFsKS5kZXBzKTtcblx0XHRmb3IgKGNvbnN0IGRlcCBvZiBkZXBzKSB7XG5cdFx0XHRsb2dfZW50cnkoZGVwKTtcblx0XHR9XG5cdH1cblxuXHRpZiAoc2lnbmFsLmNyZWF0ZWQpIHtcblx0XHQvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tY29uc29sZVxuXHRcdGNvbnNvbGUubG9nKHNpZ25hbC5jcmVhdGVkKTtcblx0fVxuXG5cdGlmIChzaWduYWwudXBkYXRlZCkge1xuXHRcdC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25zb2xlXG5cdFx0Y29uc29sZS5sb2coc2lnbmFsLnVwZGF0ZWQpO1xuXHR9XG5cblx0Y29uc3QgcmVhZCA9IGVudHJ5Py5yZWFkO1xuXG5cdGlmIChyZWFkICYmIHJlYWQubGVuZ3RoID4gMCkge1xuXHRcdGZvciAodmFyIHN0YWNrIG9mIHJlYWQpIHtcblx0XHRcdC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25zb2xlXG5cdFx0XHRjb25zb2xlLmxvZyhzdGFjayk7XG5cdFx0fVxuXHR9XG5cblx0Ly8gZXNsaW50LWRpc2FibGUtbmV4dC1saW5lIG5vLWNvbnNvbGVcblx0Y29uc29sZS5ncm91cEVuZCgpO1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSBUXG4gKiBAcGFyYW0geygpID0+IHN0cmluZ30gbGFiZWxcbiAqIEBwYXJhbSB7KCkgPT4gVH0gZm5cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHRyYWNlKGxhYmVsLCBmbikge1xuXHR2YXIgcHJldmlvdXNseV90cmFjaW5nX2V4cHJlc3Npb25zID0gdHJhY2luZ19leHByZXNzaW9ucztcblx0dHJ5IHtcblx0XHR0cmFjaW5nX2V4cHJlc3Npb25zID0geyBlbnRyaWVzOiBuZXcgTWFwKCksIHJlYWN0aW9uOiBhY3RpdmVfcmVhY3Rpb24gfTtcblxuXHRcdHZhciBzdGFydCA9IHBlcmZvcm1hbmNlLm5vdygpO1xuXHRcdHZhciB2YWx1ZSA9IGZuKCk7XG5cdFx0dmFyIHRpbWUgPSAocGVyZm9ybWFuY2Uubm93KCkgLSBzdGFydCkudG9GaXhlZCgyKTtcblxuXHRcdGlmICghZWZmZWN0X3RyYWNraW5nKCkpIHtcblx0XHRcdC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25zb2xlXG5cdFx0XHRjb25zb2xlLmxvZyhgJHtsYWJlbCgpfSAlY3JhbiBvdXRzaWRlIG9mIGFuIGVmZmVjdCAoJHt0aW1lfW1zKWAsICdjb2xvcjogZ3JleScpO1xuXHRcdH0gZWxzZSBpZiAodHJhY2luZ19leHByZXNzaW9ucy5lbnRyaWVzLnNpemUgPT09IDApIHtcblx0XHRcdC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25zb2xlXG5cdFx0XHRjb25zb2xlLmxvZyhgJHtsYWJlbCgpfSAlY25vIHJlYWN0aXZlIGRlcGVuZGVuY2llcyAoJHt0aW1lfW1zKWAsICdjb2xvcjogZ3JleScpO1xuXHRcdH0gZWxzZSB7XG5cdFx0XHQvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tY29uc29sZVxuXHRcdFx0Y29uc29sZS5ncm91cChgJHtsYWJlbCgpfSAlYygke3RpbWV9bXMpYCwgJ2NvbG9yOiBncmV5Jyk7XG5cblx0XHRcdHZhciBlbnRyaWVzID0gdHJhY2luZ19leHByZXNzaW9ucy5lbnRyaWVzO1xuXG5cdFx0XHR0cmFjaW5nX2V4cHJlc3Npb25zID0gbnVsbDtcblxuXHRcdFx0Zm9yIChjb25zdCBbc2lnbmFsLCBlbnRyeV0gb2YgZW50cmllcykge1xuXHRcdFx0XHRsb2dfZW50cnkoc2lnbmFsLCBlbnRyeSk7XG5cdFx0XHR9XG5cdFx0XHQvLyBlc2xpbnQtZGlzYWJsZS1uZXh0LWxpbmUgbm8tY29uc29sZVxuXHRcdFx0Y29uc29sZS5ncm91cEVuZCgpO1xuXHRcdH1cblxuXHRcdGlmIChwcmV2aW91c2x5X3RyYWNpbmdfZXhwcmVzc2lvbnMgIT09IG51bGwgJiYgdHJhY2luZ19leHByZXNzaW9ucyAhPT0gbnVsbCkge1xuXHRcdFx0Zm9yIChjb25zdCBbc2lnbmFsLCBlbnRyeV0gb2YgdHJhY2luZ19leHByZXNzaW9ucy5lbnRyaWVzKSB7XG5cdFx0XHRcdHZhciBwcmV2X2VudHJ5ID0gcHJldmlvdXNseV90cmFjaW5nX2V4cHJlc3Npb25zLmdldChzaWduYWwpO1xuXG5cdFx0XHRcdGlmIChwcmV2X2VudHJ5ID09PSB1bmRlZmluZWQpIHtcblx0XHRcdFx0XHRwcmV2aW91c2x5X3RyYWNpbmdfZXhwcmVzc2lvbnMuc2V0KHNpZ25hbCwgZW50cnkpO1xuXHRcdFx0XHR9IGVsc2Uge1xuXHRcdFx0XHRcdHByZXZfZW50cnkucmVhZC5wdXNoKC4uLmVudHJ5LnJlYWQpO1xuXHRcdFx0XHR9XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0cmV0dXJuIHZhbHVlO1xuXHR9IGZpbmFsbHkge1xuXHRcdHRyYWNpbmdfZXhwcmVzc2lvbnMgPSBwcmV2aW91c2x5X3RyYWNpbmdfZXhwcmVzc2lvbnM7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge3N0cmluZ30gbGFiZWxcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGdldF9zdGFjayhsYWJlbCkge1xuXHRsZXQgZXJyb3IgPSBFcnJvcigpO1xuXHRjb25zdCBzdGFjayA9IGVycm9yLnN0YWNrO1xuXG5cdGlmIChzdGFjaykge1xuXHRcdGNvbnN0IGxpbmVzID0gc3RhY2suc3BsaXQoJ1xcbicpO1xuXHRcdGNvbnN0IG5ld19saW5lcyA9IFsnXFxuJ107XG5cblx0XHRmb3IgKGxldCBpID0gMDsgaSA8IGxpbmVzLmxlbmd0aDsgaSsrKSB7XG5cdFx0XHRjb25zdCBsaW5lID0gbGluZXNbaV07XG5cblx0XHRcdGlmIChsaW5lID09PSAnRXJyb3InKSB7XG5cdFx0XHRcdGNvbnRpbnVlO1xuXHRcdFx0fVxuXHRcdFx0aWYgKGxpbmUuaW5jbHVkZXMoJ3ZhbGlkYXRlX2VhY2hfa2V5cycpKSB7XG5cdFx0XHRcdHJldHVybiBudWxsO1xuXHRcdFx0fVxuXHRcdFx0aWYgKGxpbmUuaW5jbHVkZXMoJ3N2ZWx0ZS9zcmMvaW50ZXJuYWwnKSkge1xuXHRcdFx0XHRjb250aW51ZTtcblx0XHRcdH1cblx0XHRcdG5ld19saW5lcy5wdXNoKGxpbmUpO1xuXHRcdH1cblxuXHRcdGlmIChuZXdfbGluZXMubGVuZ3RoID09PSAxKSB7XG5cdFx0XHRyZXR1cm4gbnVsbDtcblx0XHR9XG5cblx0XHRkZWZpbmVfcHJvcGVydHkoZXJyb3IsICdzdGFjaycsIHtcblx0XHRcdHZhbHVlOiBuZXdfbGluZXMuam9pbignXFxuJylcblx0XHR9KTtcblxuXHRcdGRlZmluZV9wcm9wZXJ0eShlcnJvciwgJ25hbWUnLCB7XG5cdFx0XHQvLyAnRXJyb3InIHN1ZmZpeCBpcyByZXF1aXJlZCBmb3Igc3RhY2sgdHJhY2VzIHRvIGJlIHJlbmRlcmVkIHByb3Blcmx5XG5cdFx0XHR2YWx1ZTogYCR7bGFiZWx9RXJyb3JgXG5cdFx0fSk7XG5cdH1cblx0cmV0dXJuIGVycm9yO1xufVxuIiwgIi8qIFRoaXMgZmlsZSBpcyBnZW5lcmF0ZWQgYnkgc2NyaXB0cy9wcm9jZXNzLW1lc3NhZ2VzL2luZGV4LmpzLiBEbyBub3QgZWRpdCEgKi9cblxuaW1wb3J0IHsgREVWIH0gZnJvbSAnZXNtLWVudic7XG5cbnZhciBib2xkID0gJ2ZvbnQtd2VpZ2h0OiBib2xkJztcbnZhciBub3JtYWwgPSAnZm9udC13ZWlnaHQ6IG5vcm1hbCc7XG5cbi8qKlxuICogQXNzaWdubWVudCB0byBgJXByb3BlcnR5JWAgcHJvcGVydHkgKCVsb2NhdGlvbiUpIHdpbGwgZXZhbHVhdGUgdG8gdGhlIHJpZ2h0LWhhbmQgc2lkZSwgbm90IHRoZSB2YWx1ZSBvZiBgJXByb3BlcnR5JWAgZm9sbG93aW5nIHRoZSBhc3NpZ25tZW50LiBUaGlzIG1heSByZXN1bHQgaW4gdW5leHBlY3RlZCBiZWhhdmlvdXIuXG4gKiBAcGFyYW0ge3N0cmluZ30gcHJvcGVydHlcbiAqIEBwYXJhbSB7c3RyaW5nfSBsb2NhdGlvblxuICovXG5leHBvcnQgZnVuY3Rpb24gYXNzaWdubWVudF92YWx1ZV9zdGFsZShwcm9wZXJ0eSwgbG9jYXRpb24pIHtcblx0aWYgKERFVikge1xuXHRcdGNvbnNvbGUud2FybihgJWNbc3ZlbHRlXSBhc3NpZ25tZW50X3ZhbHVlX3N0YWxlXFxuJWNBc3NpZ25tZW50IHRvIFxcYCR7cHJvcGVydHl9XFxgIHByb3BlcnR5ICgke2xvY2F0aW9ufSkgd2lsbCBldmFsdWF0ZSB0byB0aGUgcmlnaHQtaGFuZCBzaWRlLCBub3QgdGhlIHZhbHVlIG9mIFxcYCR7cHJvcGVydHl9XFxgIGZvbGxvd2luZyB0aGUgYXNzaWdubWVudC4gVGhpcyBtYXkgcmVzdWx0IGluIHVuZXhwZWN0ZWQgYmVoYXZpb3VyLlxcbmh0dHBzOi8vc3ZlbHRlLmRldi9lL2Fzc2lnbm1lbnRfdmFsdWVfc3RhbGVgLCBib2xkLCBub3JtYWwpO1xuXHR9IGVsc2Uge1xuXHRcdGNvbnNvbGUud2FybihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvYXNzaWdubWVudF92YWx1ZV9zdGFsZWApO1xuXHR9XG59XG5cbi8qKlxuICogYCViaW5kaW5nJWAgKCVsb2NhdGlvbiUpIGlzIGJpbmRpbmcgdG8gYSBub24tcmVhY3RpdmUgcHJvcGVydHlcbiAqIEBwYXJhbSB7c3RyaW5nfSBiaW5kaW5nXG4gKiBAcGFyYW0ge3N0cmluZyB8IHVuZGVmaW5lZCB8IG51bGx9IFtsb2NhdGlvbl1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGJpbmRpbmdfcHJvcGVydHlfbm9uX3JlYWN0aXZlKGJpbmRpbmcsIGxvY2F0aW9uKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zb2xlLndhcm4oYCVjW3N2ZWx0ZV0gYmluZGluZ19wcm9wZXJ0eV9ub25fcmVhY3RpdmVcXG4lYyR7bG9jYXRpb24gPyBgXFxgJHtiaW5kaW5nfVxcYCAoJHtsb2NhdGlvbn0pIGlzIGJpbmRpbmcgdG8gYSBub24tcmVhY3RpdmUgcHJvcGVydHlgIDogYFxcYCR7YmluZGluZ31cXGAgaXMgYmluZGluZyB0byBhIG5vbi1yZWFjdGl2ZSBwcm9wZXJ0eWB9XFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvYmluZGluZ19wcm9wZXJ0eV9ub25fcmVhY3RpdmVgLCBib2xkLCBub3JtYWwpO1xuXHR9IGVsc2Uge1xuXHRcdGNvbnNvbGUud2FybihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvYmluZGluZ19wcm9wZXJ0eV9ub25fcmVhY3RpdmVgKTtcblx0fVxufVxuXG4vKipcbiAqIFlvdXIgYGNvbnNvbGUuJW1ldGhvZCVgIGNvbnRhaW5lZCBgJHN0YXRlYCBwcm94aWVzLiBDb25zaWRlciB1c2luZyBgJGluc3BlY3QoLi4uKWAgb3IgYCRzdGF0ZS5zbmFwc2hvdCguLi4pYCBpbnN0ZWFkXG4gKiBAcGFyYW0ge3N0cmluZ30gbWV0aG9kXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjb25zb2xlX2xvZ19zdGF0ZShtZXRob2QpIHtcblx0aWYgKERFVikge1xuXHRcdGNvbnNvbGUud2FybihgJWNbc3ZlbHRlXSBjb25zb2xlX2xvZ19zdGF0ZVxcbiVjWW91ciBcXGBjb25zb2xlLiR7bWV0aG9kfVxcYCBjb250YWluZWQgXFxgJHN0YXRlXFxgIHByb3hpZXMuIENvbnNpZGVyIHVzaW5nIFxcYCRpbnNwZWN0KC4uLilcXGAgb3IgXFxgJHN0YXRlLnNuYXBzaG90KC4uLilcXGAgaW5zdGVhZFxcbmh0dHBzOi8vc3ZlbHRlLmRldi9lL2NvbnNvbGVfbG9nX3N0YXRlYCwgYm9sZCwgbm9ybWFsKTtcblx0fSBlbHNlIHtcblx0XHRjb25zb2xlLndhcm4oYGh0dHBzOi8vc3ZlbHRlLmRldi9lL2NvbnNvbGVfbG9nX3N0YXRlYCk7XG5cdH1cbn1cblxuLyoqXG4gKiAlaGFuZGxlciUgc2hvdWxkIGJlIGEgZnVuY3Rpb24uIERpZCB5b3UgbWVhbiB0byAlc3VnZ2VzdGlvbiU/XG4gKiBAcGFyYW0ge3N0cmluZ30gaGFuZGxlclxuICogQHBhcmFtIHtzdHJpbmd9IHN1Z2dlc3Rpb25cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGV2ZW50X2hhbmRsZXJfaW52YWxpZChoYW5kbGVyLCBzdWdnZXN0aW9uKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zb2xlLndhcm4oYCVjW3N2ZWx0ZV0gZXZlbnRfaGFuZGxlcl9pbnZhbGlkXFxuJWMke2hhbmRsZXJ9IHNob3VsZCBiZSBhIGZ1bmN0aW9uLiBEaWQgeW91IG1lYW4gdG8gJHtzdWdnZXN0aW9ufT9cXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9ldmVudF9oYW5kbGVyX2ludmFsaWRgLCBib2xkLCBub3JtYWwpO1xuXHR9IGVsc2Uge1xuXHRcdGNvbnNvbGUud2FybihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvZXZlbnRfaGFuZGxlcl9pbnZhbGlkYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBUaGUgYCVhdHRyaWJ1dGUlYCBhdHRyaWJ1dGUgb24gYCVodG1sJWAgY2hhbmdlZCBpdHMgdmFsdWUgYmV0d2VlbiBzZXJ2ZXIgYW5kIGNsaWVudCByZW5kZXJzLiBUaGUgY2xpZW50IHZhbHVlLCBgJXZhbHVlJWAsIHdpbGwgYmUgaWdub3JlZCBpbiBmYXZvdXIgb2YgdGhlIHNlcnZlciB2YWx1ZVxuICogQHBhcmFtIHtzdHJpbmd9IGF0dHJpYnV0ZVxuICogQHBhcmFtIHtzdHJpbmd9IGh0bWxcbiAqIEBwYXJhbSB7c3RyaW5nfSB2YWx1ZVxuICovXG5leHBvcnQgZnVuY3Rpb24gaHlkcmF0aW9uX2F0dHJpYnV0ZV9jaGFuZ2VkKGF0dHJpYnV0ZSwgaHRtbCwgdmFsdWUpIHtcblx0aWYgKERFVikge1xuXHRcdGNvbnNvbGUud2FybihgJWNbc3ZlbHRlXSBoeWRyYXRpb25fYXR0cmlidXRlX2NoYW5nZWRcXG4lY1RoZSBcXGAke2F0dHJpYnV0ZX1cXGAgYXR0cmlidXRlIG9uIFxcYCR7aHRtbH1cXGAgY2hhbmdlZCBpdHMgdmFsdWUgYmV0d2VlbiBzZXJ2ZXIgYW5kIGNsaWVudCByZW5kZXJzLiBUaGUgY2xpZW50IHZhbHVlLCBcXGAke3ZhbHVlfVxcYCwgd2lsbCBiZSBpZ25vcmVkIGluIGZhdm91ciBvZiB0aGUgc2VydmVyIHZhbHVlXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvaHlkcmF0aW9uX2F0dHJpYnV0ZV9jaGFuZ2VkYCwgYm9sZCwgbm9ybWFsKTtcblx0fSBlbHNlIHtcblx0XHRjb25zb2xlLndhcm4oYGh0dHBzOi8vc3ZlbHRlLmRldi9lL2h5ZHJhdGlvbl9hdHRyaWJ1dGVfY2hhbmdlZGApO1xuXHR9XG59XG5cbi8qKlxuICogVGhlIHZhbHVlIG9mIGFuIGB7QGh0bWwgLi4ufWAgYmxvY2sgJWxvY2F0aW9uJSBjaGFuZ2VkIGJldHdlZW4gc2VydmVyIGFuZCBjbGllbnQgcmVuZGVycy4gVGhlIGNsaWVudCB2YWx1ZSB3aWxsIGJlIGlnbm9yZWQgaW4gZmF2b3VyIG9mIHRoZSBzZXJ2ZXIgdmFsdWVcbiAqIEBwYXJhbSB7c3RyaW5nIHwgdW5kZWZpbmVkIHwgbnVsbH0gW2xvY2F0aW9uXVxuICovXG5leHBvcnQgZnVuY3Rpb24gaHlkcmF0aW9uX2h0bWxfY2hhbmdlZChsb2NhdGlvbikge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc29sZS53YXJuKGAlY1tzdmVsdGVdIGh5ZHJhdGlvbl9odG1sX2NoYW5nZWRcXG4lYyR7bG9jYXRpb24gPyBgVGhlIHZhbHVlIG9mIGFuIFxcYHtAaHRtbCAuLi59XFxgIGJsb2NrICR7bG9jYXRpb259IGNoYW5nZWQgYmV0d2VlbiBzZXJ2ZXIgYW5kIGNsaWVudCByZW5kZXJzLiBUaGUgY2xpZW50IHZhbHVlIHdpbGwgYmUgaWdub3JlZCBpbiBmYXZvdXIgb2YgdGhlIHNlcnZlciB2YWx1ZWAgOiAnVGhlIHZhbHVlIG9mIGFuIGB7QGh0bWwgLi4ufWAgYmxvY2sgY2hhbmdlZCBiZXR3ZWVuIHNlcnZlciBhbmQgY2xpZW50IHJlbmRlcnMuIFRoZSBjbGllbnQgdmFsdWUgd2lsbCBiZSBpZ25vcmVkIGluIGZhdm91ciBvZiB0aGUgc2VydmVyIHZhbHVlJ31cXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9oeWRyYXRpb25faHRtbF9jaGFuZ2VkYCwgYm9sZCwgbm9ybWFsKTtcblx0fSBlbHNlIHtcblx0XHRjb25zb2xlLndhcm4oYGh0dHBzOi8vc3ZlbHRlLmRldi9lL2h5ZHJhdGlvbl9odG1sX2NoYW5nZWRgKTtcblx0fVxufVxuXG4vKipcbiAqIEh5ZHJhdGlvbiBmYWlsZWQgYmVjYXVzZSB0aGUgaW5pdGlhbCBVSSBkb2VzIG5vdCBtYXRjaCB3aGF0IHdhcyByZW5kZXJlZCBvbiB0aGUgc2VydmVyLiBUaGUgZXJyb3Igb2NjdXJyZWQgbmVhciAlbG9jYXRpb24lXG4gKiBAcGFyYW0ge3N0cmluZyB8IHVuZGVmaW5lZCB8IG51bGx9IFtsb2NhdGlvbl1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGh5ZHJhdGlvbl9taXNtYXRjaChsb2NhdGlvbikge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc29sZS53YXJuKGAlY1tzdmVsdGVdIGh5ZHJhdGlvbl9taXNtYXRjaFxcbiVjJHtsb2NhdGlvbiA/IGBIeWRyYXRpb24gZmFpbGVkIGJlY2F1c2UgdGhlIGluaXRpYWwgVUkgZG9lcyBub3QgbWF0Y2ggd2hhdCB3YXMgcmVuZGVyZWQgb24gdGhlIHNlcnZlci4gVGhlIGVycm9yIG9jY3VycmVkIG5lYXIgJHtsb2NhdGlvbn1gIDogJ0h5ZHJhdGlvbiBmYWlsZWQgYmVjYXVzZSB0aGUgaW5pdGlhbCBVSSBkb2VzIG5vdCBtYXRjaCB3aGF0IHdhcyByZW5kZXJlZCBvbiB0aGUgc2VydmVyJ31cXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9oeWRyYXRpb25fbWlzbWF0Y2hgLCBib2xkLCBub3JtYWwpO1xuXHR9IGVsc2Uge1xuXHRcdGNvbnNvbGUud2FybihgaHR0cHM6Ly9zdmVsdGUuZGV2L2UvaHlkcmF0aW9uX21pc21hdGNoYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBUaGUgYHJlbmRlcmAgZnVuY3Rpb24gcGFzc2VkIHRvIGBjcmVhdGVSYXdTbmlwcGV0YCBzaG91bGQgcmV0dXJuIEhUTUwgZm9yIGEgc2luZ2xlIGVsZW1lbnRcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGludmFsaWRfcmF3X3NuaXBwZXRfcmVuZGVyKCkge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc29sZS53YXJuKGAlY1tzdmVsdGVdIGludmFsaWRfcmF3X3NuaXBwZXRfcmVuZGVyXFxuJWNUaGUgXFxgcmVuZGVyXFxgIGZ1bmN0aW9uIHBhc3NlZCB0byBcXGBjcmVhdGVSYXdTbmlwcGV0XFxgIHNob3VsZCByZXR1cm4gSFRNTCBmb3IgYSBzaW5nbGUgZWxlbWVudFxcbmh0dHBzOi8vc3ZlbHRlLmRldi9lL2ludmFsaWRfcmF3X3NuaXBwZXRfcmVuZGVyYCwgYm9sZCwgbm9ybWFsKTtcblx0fSBlbHNlIHtcblx0XHRjb25zb2xlLndhcm4oYGh0dHBzOi8vc3ZlbHRlLmRldi9lL2ludmFsaWRfcmF3X3NuaXBwZXRfcmVuZGVyYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBEZXRlY3RlZCBhIG1pZ3JhdGVkIGAkOmAgcmVhY3RpdmUgYmxvY2sgaW4gYCVmaWxlbmFtZSVgIHRoYXQgYm90aCBhY2Nlc3NlcyBhbmQgdXBkYXRlcyB0aGUgc2FtZSByZWFjdGl2ZSB2YWx1ZS4gVGhpcyBtYXkgY2F1c2UgcmVjdXJzaXZlIHVwZGF0ZXMgd2hlbiBjb252ZXJ0ZWQgdG8gYW4gYCRlZmZlY3RgLlxuICogQHBhcmFtIHtzdHJpbmd9IGZpbGVuYW1lXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBsZWdhY3lfcmVjdXJzaXZlX3JlYWN0aXZlX2Jsb2NrKGZpbGVuYW1lKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zb2xlLndhcm4oYCVjW3N2ZWx0ZV0gbGVnYWN5X3JlY3Vyc2l2ZV9yZWFjdGl2ZV9ibG9ja1xcbiVjRGV0ZWN0ZWQgYSBtaWdyYXRlZCBcXGAkOlxcYCByZWFjdGl2ZSBibG9jayBpbiBcXGAke2ZpbGVuYW1lfVxcYCB0aGF0IGJvdGggYWNjZXNzZXMgYW5kIHVwZGF0ZXMgdGhlIHNhbWUgcmVhY3RpdmUgdmFsdWUuIFRoaXMgbWF5IGNhdXNlIHJlY3Vyc2l2ZSB1cGRhdGVzIHdoZW4gY29udmVydGVkIHRvIGFuIFxcYCRlZmZlY3RcXGAuXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvbGVnYWN5X3JlY3Vyc2l2ZV9yZWFjdGl2ZV9ibG9ja2AsIGJvbGQsIG5vcm1hbCk7XG5cdH0gZWxzZSB7XG5cdFx0Y29uc29sZS53YXJuKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9sZWdhY3lfcmVjdXJzaXZlX3JlYWN0aXZlX2Jsb2NrYCk7XG5cdH1cbn1cblxuLyoqXG4gKiBUcmllZCB0byB1bm1vdW50IGEgY29tcG9uZW50IHRoYXQgd2FzIG5vdCBtb3VudGVkXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBsaWZlY3ljbGVfZG91YmxlX3VubW91bnQoKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zb2xlLndhcm4oYCVjW3N2ZWx0ZV0gbGlmZWN5Y2xlX2RvdWJsZV91bm1vdW50XFxuJWNUcmllZCB0byB1bm1vdW50IGEgY29tcG9uZW50IHRoYXQgd2FzIG5vdCBtb3VudGVkXFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2UvbGlmZWN5Y2xlX2RvdWJsZV91bm1vdW50YCwgYm9sZCwgbm9ybWFsKTtcblx0fSBlbHNlIHtcblx0XHRjb25zb2xlLndhcm4oYGh0dHBzOi8vc3ZlbHRlLmRldi9lL2xpZmVjeWNsZV9kb3VibGVfdW5tb3VudGApO1xuXHR9XG59XG5cbi8qKlxuICogJXBhcmVudCUgcGFzc2VkIGEgdmFsdWUgdG8gJWNoaWxkJSB3aXRoIGBiaW5kOmAsIGJ1dCB0aGUgdmFsdWUgaXMgb3duZWQgYnkgJW93bmVyJS4gQ29uc2lkZXIgY3JlYXRpbmcgYSBiaW5kaW5nIGJldHdlZW4gJW93bmVyJSBhbmQgJXBhcmVudCVcbiAqIEBwYXJhbSB7c3RyaW5nfSBwYXJlbnRcbiAqIEBwYXJhbSB7c3RyaW5nfSBjaGlsZFxuICogQHBhcmFtIHtzdHJpbmd9IG93bmVyXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBvd25lcnNoaXBfaW52YWxpZF9iaW5kaW5nKHBhcmVudCwgY2hpbGQsIG93bmVyKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zb2xlLndhcm4oYCVjW3N2ZWx0ZV0gb3duZXJzaGlwX2ludmFsaWRfYmluZGluZ1xcbiVjJHtwYXJlbnR9IHBhc3NlZCBhIHZhbHVlIHRvICR7Y2hpbGR9IHdpdGggXFxgYmluZDpcXGAsIGJ1dCB0aGUgdmFsdWUgaXMgb3duZWQgYnkgJHtvd25lcn0uIENvbnNpZGVyIGNyZWF0aW5nIGEgYmluZGluZyBiZXR3ZWVuICR7b3duZXJ9IGFuZCAke3BhcmVudH1cXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9vd25lcnNoaXBfaW52YWxpZF9iaW5kaW5nYCwgYm9sZCwgbm9ybWFsKTtcblx0fSBlbHNlIHtcblx0XHRjb25zb2xlLndhcm4oYGh0dHBzOi8vc3ZlbHRlLmRldi9lL293bmVyc2hpcF9pbnZhbGlkX2JpbmRpbmdgKTtcblx0fVxufVxuXG4vKipcbiAqICVjb21wb25lbnQlIG11dGF0ZWQgYSB2YWx1ZSBvd25lZCBieSAlb3duZXIlLiBUaGlzIGlzIHN0cm9uZ2x5IGRpc2NvdXJhZ2VkLiBDb25zaWRlciBwYXNzaW5nIHZhbHVlcyB0byBjaGlsZCBjb21wb25lbnRzIHdpdGggYGJpbmQ6YCwgb3IgdXNlIGEgY2FsbGJhY2sgaW5zdGVhZFxuICogQHBhcmFtIHtzdHJpbmcgfCB1bmRlZmluZWQgfCBudWxsfSBbY29tcG9uZW50XVxuICogQHBhcmFtIHtzdHJpbmcgfCB1bmRlZmluZWQgfCBudWxsfSBbb3duZXJdXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBvd25lcnNoaXBfaW52YWxpZF9tdXRhdGlvbihjb21wb25lbnQsIG93bmVyKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zb2xlLndhcm4oYCVjW3N2ZWx0ZV0gb3duZXJzaGlwX2ludmFsaWRfbXV0YXRpb25cXG4lYyR7Y29tcG9uZW50ID8gYCR7Y29tcG9uZW50fSBtdXRhdGVkIGEgdmFsdWUgb3duZWQgYnkgJHtvd25lcn0uIFRoaXMgaXMgc3Ryb25nbHkgZGlzY291cmFnZWQuIENvbnNpZGVyIHBhc3NpbmcgdmFsdWVzIHRvIGNoaWxkIGNvbXBvbmVudHMgd2l0aCBcXGBiaW5kOlxcYCwgb3IgdXNlIGEgY2FsbGJhY2sgaW5zdGVhZGAgOiAnTXV0YXRpbmcgYSB2YWx1ZSBvdXRzaWRlIHRoZSBjb21wb25lbnQgdGhhdCBjcmVhdGVkIGl0IGlzIHN0cm9uZ2x5IGRpc2NvdXJhZ2VkLiBDb25zaWRlciBwYXNzaW5nIHZhbHVlcyB0byBjaGlsZCBjb21wb25lbnRzIHdpdGggYGJpbmQ6YCwgb3IgdXNlIGEgY2FsbGJhY2sgaW5zdGVhZCd9XFxuaHR0cHM6Ly9zdmVsdGUuZGV2L2Uvb3duZXJzaGlwX2ludmFsaWRfbXV0YXRpb25gLCBib2xkLCBub3JtYWwpO1xuXHR9IGVsc2Uge1xuXHRcdGNvbnNvbGUud2FybihgaHR0cHM6Ly9zdmVsdGUuZGV2L2Uvb3duZXJzaGlwX2ludmFsaWRfbXV0YXRpb25gKTtcblx0fVxufVxuXG4vKipcbiAqIFJlYWN0aXZlIGAkc3RhdGUoLi4uKWAgcHJveGllcyBhbmQgdGhlIHZhbHVlcyB0aGV5IHByb3h5IGhhdmUgZGlmZmVyZW50IGlkZW50aXRpZXMuIEJlY2F1c2Ugb2YgdGhpcywgY29tcGFyaXNvbnMgd2l0aCBgJW9wZXJhdG9yJWAgd2lsbCBwcm9kdWNlIHVuZXhwZWN0ZWQgcmVzdWx0c1xuICogQHBhcmFtIHtzdHJpbmd9IG9wZXJhdG9yXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzdGF0ZV9wcm94eV9lcXVhbGl0eV9taXNtYXRjaChvcGVyYXRvcikge1xuXHRpZiAoREVWKSB7XG5cdFx0Y29uc29sZS53YXJuKGAlY1tzdmVsdGVdIHN0YXRlX3Byb3h5X2VxdWFsaXR5X21pc21hdGNoXFxuJWNSZWFjdGl2ZSBcXGAkc3RhdGUoLi4uKVxcYCBwcm94aWVzIGFuZCB0aGUgdmFsdWVzIHRoZXkgcHJveHkgaGF2ZSBkaWZmZXJlbnQgaWRlbnRpdGllcy4gQmVjYXVzZSBvZiB0aGlzLCBjb21wYXJpc29ucyB3aXRoIFxcYCR7b3BlcmF0b3J9XFxgIHdpbGwgcHJvZHVjZSB1bmV4cGVjdGVkIHJlc3VsdHNcXG5odHRwczovL3N2ZWx0ZS5kZXYvZS9zdGF0ZV9wcm94eV9lcXVhbGl0eV9taXNtYXRjaGAsIGJvbGQsIG5vcm1hbCk7XG5cdH0gZWxzZSB7XG5cdFx0Y29uc29sZS53YXJuKGBodHRwczovL3N2ZWx0ZS5kZXYvZS9zdGF0ZV9wcm94eV9lcXVhbGl0eV9taXNtYXRjaGApO1xuXHR9XG59XG5cbi8qKlxuICogVGhlIGBzbGlkZWAgdHJhbnNpdGlvbiBkb2VzIG5vdCB3b3JrIGNvcnJlY3RseSBmb3IgZWxlbWVudHMgd2l0aCBgZGlzcGxheTogJXZhbHVlJWBcbiAqIEBwYXJhbSB7c3RyaW5nfSB2YWx1ZVxuICovXG5leHBvcnQgZnVuY3Rpb24gdHJhbnNpdGlvbl9zbGlkZV9kaXNwbGF5KHZhbHVlKSB7XG5cdGlmIChERVYpIHtcblx0XHRjb25zb2xlLndhcm4oYCVjW3N2ZWx0ZV0gdHJhbnNpdGlvbl9zbGlkZV9kaXNwbGF5XFxuJWNUaGUgXFxgc2xpZGVcXGAgdHJhbnNpdGlvbiBkb2VzIG5vdCB3b3JrIGNvcnJlY3RseSBmb3IgZWxlbWVudHMgd2l0aCBcXGBkaXNwbGF5OiAke3ZhbHVlfVxcYFxcbmh0dHBzOi8vc3ZlbHRlLmRldi9lL3RyYW5zaXRpb25fc2xpZGVfZGlzcGxheWAsIGJvbGQsIG5vcm1hbCk7XG5cdH0gZWxzZSB7XG5cdFx0Y29uc29sZS53YXJuKGBodHRwczovL3N2ZWx0ZS5kZXYvZS90cmFuc2l0aW9uX3NsaWRlX2Rpc3BsYXlgKTtcblx0fVxufSIsICIvKiogQGltcG9ydCB7IFByb3h5TWV0YWRhdGEgfSBmcm9tICcjY2xpZW50JyAqL1xuLyoqIEB0eXBlZGVmIHt7IGZpbGU6IHN0cmluZywgbGluZTogbnVtYmVyLCBjb2x1bW46IG51bWJlciB9fSBMb2NhdGlvbiAqL1xuXG5pbXBvcnQgeyBTVEFURV9TWU1CT0xfTUVUQURBVEEgfSBmcm9tICcuLi9jb25zdGFudHMuanMnO1xuaW1wb3J0IHsgcmVuZGVyX2VmZmVjdCwgdXNlcl9wcmVfZWZmZWN0IH0gZnJvbSAnLi4vcmVhY3Rpdml0eS9lZmZlY3RzLmpzJztcbmltcG9ydCB7IGRldl9jdXJyZW50X2NvbXBvbmVudF9mdW5jdGlvbiB9IGZyb20gJy4uL2NvbnRleHQuanMnO1xuaW1wb3J0IHsgZ2V0X3Byb3RvdHlwZV9vZiB9IGZyb20gJy4uLy4uL3NoYXJlZC91dGlscy5qcyc7XG5pbXBvcnQgKiBhcyB3IGZyb20gJy4uL3dhcm5pbmdzLmpzJztcbmltcG9ydCB7IEZJTEVOQU1FLCBVTklOSVRJQUxJWkVEIH0gZnJvbSAnLi4vLi4vLi4vY29uc3RhbnRzLmpzJztcblxuLyoqIEB0eXBlIHtSZWNvcmQ8c3RyaW5nLCBBcnJheTx7IHN0YXJ0OiBMb2NhdGlvbiwgZW5kOiBMb2NhdGlvbiwgY29tcG9uZW50OiBGdW5jdGlvbiB9Pj59ICovXG5jb25zdCBib3VuZGFyaWVzID0ge307XG5cbmNvbnN0IGNocm9tZV9wYXR0ZXJuID0gL2F0ICg/Oi4rIFxcKCk/KC4rKTooXFxkKyk6KFxcZCspXFwpPyQvO1xuY29uc3QgZmlyZWZveF9wYXR0ZXJuID0gL0AoLispOihcXGQrKTooXFxkKykkLztcblxuZnVuY3Rpb24gZ2V0X3N0YWNrKCkge1xuXHRjb25zdCBzdGFjayA9IG5ldyBFcnJvcigpLnN0YWNrO1xuXHRpZiAoIXN0YWNrKSByZXR1cm4gbnVsbDtcblxuXHRjb25zdCBlbnRyaWVzID0gW107XG5cblx0Zm9yIChjb25zdCBsaW5lIG9mIHN0YWNrLnNwbGl0KCdcXG4nKSkge1xuXHRcdGxldCBtYXRjaCA9IGNocm9tZV9wYXR0ZXJuLmV4ZWMobGluZSkgPz8gZmlyZWZveF9wYXR0ZXJuLmV4ZWMobGluZSk7XG5cblx0XHRpZiAobWF0Y2gpIHtcblx0XHRcdGVudHJpZXMucHVzaCh7XG5cdFx0XHRcdGZpbGU6IG1hdGNoWzFdLFxuXHRcdFx0XHRsaW5lOiArbWF0Y2hbMl0sXG5cdFx0XHRcdGNvbHVtbjogK21hdGNoWzNdXG5cdFx0XHR9KTtcblx0XHR9XG5cdH1cblxuXHRyZXR1cm4gZW50cmllcztcbn1cblxuLyoqXG4gKiBEZXRlcm1pbmVzIHdoaWNoIGAuc3ZlbHRlYCBjb21wb25lbnQgaXMgcmVzcG9uc2libGUgZm9yIGEgZ2l2ZW4gc3RhdGUgY2hhbmdlXG4gKiBAcmV0dXJucyB7RnVuY3Rpb24gfCBudWxsfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZ2V0X2NvbXBvbmVudCgpIHtcblx0Ly8gZmlyc3QgNCBsaW5lcyBhcmUgc3ZlbHRlIGludGVybmFsczsgYWRqdXN0IHRoaXMgbnVtYmVyIGlmIHdlIGNoYW5nZSB0aGUgaW50ZXJuYWwgY2FsbCBzdGFja1xuXHRjb25zdCBzdGFjayA9IGdldF9zdGFjaygpPy5zbGljZSg0KTtcblx0aWYgKCFzdGFjaykgcmV0dXJuIG51bGw7XG5cblx0Zm9yIChsZXQgaSA9IDA7IGkgPCBzdGFjay5sZW5ndGg7IGkrKykge1xuXHRcdGNvbnN0IGVudHJ5ID0gc3RhY2tbaV07XG5cdFx0Y29uc3QgbW9kdWxlcyA9IGJvdW5kYXJpZXNbZW50cnkuZmlsZV07XG5cdFx0aWYgKCFtb2R1bGVzKSB7XG5cdFx0XHQvLyBJZiB0aGUgZmlyc3QgZW50cnkgaXMgbm90IGEgY29tcG9uZW50LCB0aGF0IG1lYW5zIHRoZSBtb2RpZmljYXRpb24gdmVyeSBsaWtlbHkgaGFwcGVuZWRcblx0XHRcdC8vIHdpdGhpbiBhIC5zdmVsdGUuanMgZmlsZSwgcG9zc2libHkgdHJpZ2dlcmVkIGJ5IGEgY29tcG9uZW50LiBTaW5jZSB0aGVzZSBmaWxlcyBhcmUgbm90IHBhcnRcblx0XHRcdC8vIG9mIHRoZSBib25kYXJpZXMvY29tcG9uZW50IGNvbnRleHQgaGV1cmlzdGljLCB3ZSBuZWVkIHRvIGJhaWwgaW4gdGhpcyBjYXNlLCBlbHNlIHdlIHdvdWxkXG5cdFx0XHQvLyBoYXZlIGZhbHNlIHBvc2l0aXZlcyB3aGVuIHRoZSAuc3ZlbHRlLnRzIGZpbGUgcHJvdmlkZXMgYSBzdGF0ZSBjcmVhdG9yIGZ1bmN0aW9uLCBlbmNhcHN1bGF0aW5nXG5cdFx0XHQvLyB0aGUgc3RhdGUgYW5kIGl0cyBtdXRhdGlvbnMsIGFuZCBpcyBiZWluZyBjYWxsZWQgZnJvbSBhIGNvbXBvbmVudCBvdGhlciB0aGFuIHRoZSBvbmUgd2hvXG5cdFx0XHQvLyBjYWxsZWQgdGhlIHN0YXRlIGNyZWF0b3IgZnVuY3Rpb24uXG5cdFx0XHRpZiAoaSA9PT0gMCkgcmV0dXJuIG51bGw7XG5cdFx0XHRjb250aW51ZTtcblx0XHR9XG5cblx0XHRmb3IgKGNvbnN0IG1vZHVsZSBvZiBtb2R1bGVzKSB7XG5cdFx0XHRpZiAobW9kdWxlLmVuZCA9PSBudWxsKSB7XG5cdFx0XHRcdHJldHVybiBudWxsO1xuXHRcdFx0fVxuXHRcdFx0aWYgKG1vZHVsZS5zdGFydC5saW5lIDwgZW50cnkubGluZSAmJiBtb2R1bGUuZW5kLmxpbmUgPiBlbnRyeS5saW5lKSB7XG5cdFx0XHRcdHJldHVybiBtb2R1bGUuY29tcG9uZW50O1xuXHRcdFx0fVxuXHRcdH1cblx0fVxuXG5cdHJldHVybiBudWxsO1xufVxuXG5leHBvcnQgY29uc3QgQUREX09XTkVSID0gU3ltYm9sKCdBRERfT1dORVInKTtcblxuLyoqXG4gKiBUb2dldGhlciB3aXRoIGBtYXJrX21vZHVsZV9lbmRgLCB0aGlzIGZ1bmN0aW9uIGVzdGFibGlzaGVzIHRoZSBib3VuZGFyaWVzIG9mIGEgYC5zdmVsdGVgIGZpbGUsXG4gKiBzdWNoIHRoYXQgc3Vic2VxdWVudCBjYWxscyB0byBgZ2V0X2NvbXBvbmVudGAgY2FuIHRlbGwgdXMgd2hpY2ggY29tcG9uZW50IGlzIHJlc3BvbnNpYmxlXG4gKiBmb3IgYSBnaXZlbiBzdGF0ZSBjaGFuZ2VcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIG1hcmtfbW9kdWxlX3N0YXJ0KCkge1xuXHRjb25zdCBzdGFydCA9IGdldF9zdGFjaygpPy5bMl07XG5cblx0aWYgKHN0YXJ0KSB7XG5cdFx0KGJvdW5kYXJpZXNbc3RhcnQuZmlsZV0gPz89IFtdKS5wdXNoKHtcblx0XHRcdHN0YXJ0LFxuXHRcdFx0Ly8gQHRzLWV4cGVjdC1lcnJvclxuXHRcdFx0ZW5kOiBudWxsLFxuXHRcdFx0Ly8gQHRzLWV4cGVjdC1lcnJvciB3ZSBhZGQgdGhlIGNvbXBvbmVudCBhdCB0aGUgZW5kLCBzaW5jZSBITVIgd2lsbCBvdmVyd3JpdGUgdGhlIGZ1bmN0aW9uXG5cdFx0XHRjb21wb25lbnQ6IG51bGxcblx0XHR9KTtcblx0fVxufVxuXG4vKipcbiAqIEBwYXJhbSB7RnVuY3Rpb259IGNvbXBvbmVudFxuICovXG5leHBvcnQgZnVuY3Rpb24gbWFya19tb2R1bGVfZW5kKGNvbXBvbmVudCkge1xuXHRjb25zdCBlbmQgPSBnZXRfc3RhY2soKT8uWzJdO1xuXG5cdGlmIChlbmQpIHtcblx0XHRjb25zdCBib3VuZGFyaWVzX2ZpbGUgPSBib3VuZGFyaWVzW2VuZC5maWxlXTtcblx0XHRjb25zdCBib3VuZGFyeSA9IGJvdW5kYXJpZXNfZmlsZVtib3VuZGFyaWVzX2ZpbGUubGVuZ3RoIC0gMV07XG5cblx0XHRib3VuZGFyeS5lbmQgPSBlbmQ7XG5cdFx0Ym91bmRhcnkuY29tcG9uZW50ID0gY29tcG9uZW50O1xuXHR9XG59XG5cbi8qKlxuICogQHBhcmFtIHthbnl9IG9iamVjdFxuICogQHBhcmFtIHthbnkgfCBudWxsfSBvd25lclxuICogQHBhcmFtIHtib29sZWFufSBbZ2xvYmFsXVxuICogQHBhcmFtIHtib29sZWFufSBbc2tpcF93YXJuaW5nXVxuICovXG5leHBvcnQgZnVuY3Rpb24gYWRkX293bmVyKG9iamVjdCwgb3duZXIsIGdsb2JhbCA9IGZhbHNlLCBza2lwX3dhcm5pbmcgPSBmYWxzZSkge1xuXHRpZiAob2JqZWN0ICYmICFnbG9iYWwpIHtcblx0XHRjb25zdCBjb21wb25lbnQgPSBkZXZfY3VycmVudF9jb21wb25lbnRfZnVuY3Rpb247XG5cdFx0Y29uc3QgbWV0YWRhdGEgPSBvYmplY3RbU1RBVEVfU1lNQk9MX01FVEFEQVRBXTtcblx0XHRpZiAobWV0YWRhdGEgJiYgIWhhc19vd25lcihtZXRhZGF0YSwgY29tcG9uZW50KSkge1xuXHRcdFx0bGV0IG9yaWdpbmFsID0gZ2V0X293bmVyKG1ldGFkYXRhKTtcblxuXHRcdFx0aWYgKG93bmVyICYmIG93bmVyW0ZJTEVOQU1FXSAhPT0gY29tcG9uZW50W0ZJTEVOQU1FXSAmJiAhc2tpcF93YXJuaW5nKSB7XG5cdFx0XHRcdHcub3duZXJzaGlwX2ludmFsaWRfYmluZGluZyhjb21wb25lbnRbRklMRU5BTUVdLCBvd25lcltGSUxFTkFNRV0sIG9yaWdpbmFsW0ZJTEVOQU1FXSk7XG5cdFx0XHR9XG5cdFx0fVxuXHR9XG5cblx0YWRkX293bmVyX3RvX29iamVjdChvYmplY3QsIG93bmVyLCBuZXcgU2V0KCkpO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7KCkgPT4gdW5rbm93bn0gZ2V0X29iamVjdFxuICogQHBhcmFtIHthbnl9IENvbXBvbmVudFxuICogQHBhcmFtIHtib29sZWFufSBbc2tpcF93YXJuaW5nXVxuICovXG5leHBvcnQgZnVuY3Rpb24gYWRkX293bmVyX2VmZmVjdChnZXRfb2JqZWN0LCBDb21wb25lbnQsIHNraXBfd2FybmluZyA9IGZhbHNlKSB7XG5cdHVzZXJfcHJlX2VmZmVjdCgoKSA9PiB7XG5cdFx0YWRkX293bmVyKGdldF9vYmplY3QoKSwgQ29tcG9uZW50LCBmYWxzZSwgc2tpcF93YXJuaW5nKTtcblx0fSk7XG59XG5cbi8qKlxuICogQHBhcmFtIHthbnl9IF90aGlzXG4gKiBAcGFyYW0ge0Z1bmN0aW9ufSBvd25lclxuICogQHBhcmFtIHtBcnJheTwoKSA9PiBhbnk+fSBnZXR0ZXJzXG4gKiBAcGFyYW0ge2Jvb2xlYW59IHNraXBfd2FybmluZ1xuICovXG5leHBvcnQgZnVuY3Rpb24gYWRkX293bmVyX3RvX2NsYXNzKF90aGlzLCBvd25lciwgZ2V0dGVycywgc2tpcF93YXJuaW5nKSB7XG5cdF90aGlzW0FERF9PV05FUl0uY3VycmVudCB8fD0gZ2V0dGVycy5tYXAoKCkgPT4gVU5JTklUSUFMSVpFRCk7XG5cblx0Zm9yIChsZXQgaSA9IDA7IGkgPCBnZXR0ZXJzLmxlbmd0aDsgaSArPSAxKSB7XG5cdFx0Y29uc3QgY3VycmVudCA9IGdldHRlcnNbaV0oKTtcblx0XHQvLyBGb3IgcGVyZm9ybWFuY2UgcmVhc29ucyB3ZSBvbmx5IHJlLWFkZCB0aGUgb3duZXIgaWYgdGhlIHN0YXRlIGhhcyBjaGFuZ2VkXG5cdFx0aWYgKGN1cnJlbnQgIT09IF90aGlzW0FERF9PV05FUl1baV0pIHtcblx0XHRcdF90aGlzW0FERF9PV05FUl0uY3VycmVudFtpXSA9IGN1cnJlbnQ7XG5cdFx0XHRhZGRfb3duZXIoY3VycmVudCwgb3duZXIsIGZhbHNlLCBza2lwX3dhcm5pbmcpO1xuXHRcdH1cblx0fVxufVxuXG4vKipcbiAqIEBwYXJhbSB7UHJveHlNZXRhZGF0YSB8IG51bGx9IGZyb21cbiAqIEBwYXJhbSB7UHJveHlNZXRhZGF0YX0gdG9cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHdpZGVuX293bmVyc2hpcChmcm9tLCB0bykge1xuXHRpZiAodG8ub3duZXJzID09PSBudWxsKSB7XG5cdFx0cmV0dXJuO1xuXHR9XG5cblx0d2hpbGUgKGZyb20pIHtcblx0XHRpZiAoZnJvbS5vd25lcnMgPT09IG51bGwpIHtcblx0XHRcdHRvLm93bmVycyA9IG51bGw7XG5cdFx0XHRicmVhaztcblx0XHR9XG5cblx0XHRmb3IgKGNvbnN0IG93bmVyIG9mIGZyb20ub3duZXJzKSB7XG5cdFx0XHR0by5vd25lcnMuYWRkKG93bmVyKTtcblx0XHR9XG5cblx0XHRmcm9tID0gZnJvbS5wYXJlbnQ7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge2FueX0gb2JqZWN0XG4gKiBAcGFyYW0ge0Z1bmN0aW9uIHwgbnVsbH0gb3duZXIgSWYgYG51bGxgLCB0aGVuIHRoZSBvYmplY3QgaXMgZ2xvYmFsbHkgb3duZWQgYW5kIHdpbGwgbm90IGJlIGNoZWNrZWRcbiAqIEBwYXJhbSB7U2V0PGFueT59IHNlZW5cbiAqL1xuZnVuY3Rpb24gYWRkX293bmVyX3RvX29iamVjdChvYmplY3QsIG93bmVyLCBzZWVuKSB7XG5cdGNvbnN0IG1ldGFkYXRhID0gLyoqIEB0eXBlIHtQcm94eU1ldGFkYXRhfSAqLyAob2JqZWN0Py5bU1RBVEVfU1lNQk9MX01FVEFEQVRBXSk7XG5cblx0aWYgKG1ldGFkYXRhKSB7XG5cdFx0Ly8gdGhpcyBpcyBhIHN0YXRlIHByb3h5LCBhZGQgb3duZXIgZGlyZWN0bHksIGlmIG5vdCBnbG9iYWxseSBzaGFyZWRcblx0XHRpZiAoJ293bmVycycgaW4gbWV0YWRhdGEgJiYgbWV0YWRhdGEub3duZXJzICE9IG51bGwpIHtcblx0XHRcdGlmIChvd25lcikge1xuXHRcdFx0XHRtZXRhZGF0YS5vd25lcnMuYWRkKG93bmVyKTtcblx0XHRcdH0gZWxzZSB7XG5cdFx0XHRcdG1ldGFkYXRhLm93bmVycyA9IG51bGw7XG5cdFx0XHR9XG5cdFx0fVxuXHR9IGVsc2UgaWYgKG9iamVjdCAmJiB0eXBlb2Ygb2JqZWN0ID09PSAnb2JqZWN0Jykge1xuXHRcdGlmIChzZWVuLmhhcyhvYmplY3QpKSByZXR1cm47XG5cdFx0c2Vlbi5hZGQob2JqZWN0KTtcblx0XHRpZiAoQUREX09XTkVSIGluIG9iamVjdCAmJiBvYmplY3RbQUREX09XTkVSXSkge1xuXHRcdFx0Ly8gdGhpcyBpcyBhIGNsYXNzIHdpdGggc3RhdGUgZmllbGRzLiB3ZSBwdXQgdGhpcyBpbiBhIHJlbmRlciBlZmZlY3Rcblx0XHRcdC8vIHNvIHRoYXQgaWYgc3RhdGUgaXMgcmVwbGFjZWQgKGUuZy4gYGluc3RhbmNlLm5hbWUgPSB7IGZpcnN0LCBsYXN0IH1gKVxuXHRcdFx0Ly8gdGhlIG5ldyBzdGF0ZSBpcyBhbHNvIGNvLW93bmVkIGJ5IHRoZSBjYWxsZXIgb2YgYGdldENvbnRleHRgXG5cdFx0XHRyZW5kZXJfZWZmZWN0KCgpID0+IHtcblx0XHRcdFx0b2JqZWN0W0FERF9PV05FUl0ob3duZXIpO1xuXHRcdFx0fSk7XG5cdFx0fSBlbHNlIHtcblx0XHRcdHZhciBwcm90byA9IGdldF9wcm90b3R5cGVfb2Yob2JqZWN0KTtcblxuXHRcdFx0aWYgKHByb3RvID09PSBPYmplY3QucHJvdG90eXBlKSB7XG5cdFx0XHRcdC8vIHJlY3Vyc2UgdW50aWwgd2UgZmluZCBhIHN0YXRlIHByb3h5XG5cdFx0XHRcdGZvciAoY29uc3Qga2V5IGluIG9iamVjdCkge1xuXHRcdFx0XHRcdGlmIChPYmplY3QuZ2V0T3duUHJvcGVydHlEZXNjcmlwdG9yKG9iamVjdCwga2V5KT8uZ2V0KSB7XG5cdFx0XHRcdFx0XHQvLyBTaW1pbGFyIHRvIHRoZSBjbGFzcyBjYXNlOyB0aGUgZ2V0dGVyIGNvdWxkIHVwZGF0ZSB3aXRoIGEgbmV3IHN0YXRlXG5cdFx0XHRcdFx0XHRsZXQgY3VycmVudCA9IFVOSU5JVElBTElaRUQ7XG5cdFx0XHRcdFx0XHRyZW5kZXJfZWZmZWN0KCgpID0+IHtcblx0XHRcdFx0XHRcdFx0Y29uc3QgbmV4dCA9IG9iamVjdFtrZXldO1xuXHRcdFx0XHRcdFx0XHRpZiAoY3VycmVudCAhPT0gbmV4dCkge1xuXHRcdFx0XHRcdFx0XHRcdGN1cnJlbnQgPSBuZXh0O1xuXHRcdFx0XHRcdFx0XHRcdGFkZF9vd25lcl90b19vYmplY3QobmV4dCwgb3duZXIsIHNlZW4pO1xuXHRcdFx0XHRcdFx0XHR9XG5cdFx0XHRcdFx0XHR9KTtcblx0XHRcdFx0XHR9IGVsc2Uge1xuXHRcdFx0XHRcdFx0YWRkX293bmVyX3RvX29iamVjdChvYmplY3Rba2V5XSwgb3duZXIsIHNlZW4pO1xuXHRcdFx0XHRcdH1cblx0XHRcdFx0fVxuXHRcdFx0fSBlbHNlIGlmIChwcm90byA9PT0gQXJyYXkucHJvdG90eXBlKSB7XG5cdFx0XHRcdC8vIHJlY3Vyc2UgdW50aWwgd2UgZmluZCBhIHN0YXRlIHByb3h5XG5cdFx0XHRcdGZvciAobGV0IGkgPSAwOyBpIDwgb2JqZWN0Lmxlbmd0aDsgaSArPSAxKSB7XG5cdFx0XHRcdFx0YWRkX293bmVyX3RvX29iamVjdChvYmplY3RbaV0sIG93bmVyLCBzZWVuKTtcblx0XHRcdFx0fVxuXHRcdFx0fVxuXHRcdH1cblx0fVxufVxuXG4vKipcbiAqIEBwYXJhbSB7UHJveHlNZXRhZGF0YX0gbWV0YWRhdGFcbiAqIEBwYXJhbSB7RnVuY3Rpb259IGNvbXBvbmVudFxuICogQHJldHVybnMge2Jvb2xlYW59XG4gKi9cbmZ1bmN0aW9uIGhhc19vd25lcihtZXRhZGF0YSwgY29tcG9uZW50KSB7XG5cdGlmIChtZXRhZGF0YS5vd25lcnMgPT09IG51bGwpIHtcblx0XHRyZXR1cm4gdHJ1ZTtcblx0fVxuXG5cdHJldHVybiAoXG5cdFx0bWV0YWRhdGEub3duZXJzLmhhcyhjb21wb25lbnQpIHx8XG5cdFx0Ly8gVGhpcyBoZWxwcyBhdm9pZCBmYWxzZSBwb3NpdGl2ZXMgd2hlbiB1c2luZyBITVIsIHdoZXJlIHRoZSBjb21wb25lbnQgZnVuY3Rpb24gaXMgcmVwbGFjZWRcblx0XHQoRklMRU5BTUUgaW4gY29tcG9uZW50ICYmXG5cdFx0XHRbLi4ubWV0YWRhdGEub3duZXJzXS5zb21lKFxuXHRcdFx0XHQob3duZXIpID0+IC8qKiBAdHlwZSB7YW55fSAqLyAob3duZXIpW0ZJTEVOQU1FXSA9PT0gY29tcG9uZW50W0ZJTEVOQU1FXVxuXHRcdFx0KSkgfHxcblx0XHQobWV0YWRhdGEucGFyZW50ICE9PSBudWxsICYmIGhhc19vd25lcihtZXRhZGF0YS5wYXJlbnQsIGNvbXBvbmVudCkpXG5cdCk7XG59XG5cbi8qKlxuICogQHBhcmFtIHtQcm94eU1ldGFkYXRhfSBtZXRhZGF0YVxuICogQHJldHVybnMge2FueX1cbiAqL1xuZnVuY3Rpb24gZ2V0X293bmVyKG1ldGFkYXRhKSB7XG5cdHJldHVybiAoXG5cdFx0bWV0YWRhdGE/Lm93bmVycz8udmFsdWVzKCkubmV4dCgpLnZhbHVlID8/XG5cdFx0Z2V0X293bmVyKC8qKiBAdHlwZSB7UHJveHlNZXRhZGF0YX0gKi8gKG1ldGFkYXRhLnBhcmVudCkpXG5cdCk7XG59XG5cbmxldCBza2lwID0gZmFsc2U7XG5cbi8qKlxuICogQHBhcmFtIHsoKSA9PiBhbnl9IGZuXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBza2lwX293bmVyc2hpcF92YWxpZGF0aW9uKGZuKSB7XG5cdHNraXAgPSB0cnVlO1xuXHRmbigpO1xuXHRza2lwID0gZmFsc2U7XG59XG5cbi8qKlxuICogQHBhcmFtIHtQcm94eU1ldGFkYXRhfSBtZXRhZGF0YVxuICovXG5leHBvcnQgZnVuY3Rpb24gY2hlY2tfb3duZXJzaGlwKG1ldGFkYXRhKSB7XG5cdGlmIChza2lwKSByZXR1cm47XG5cblx0Y29uc3QgY29tcG9uZW50ID0gZ2V0X2NvbXBvbmVudCgpO1xuXG5cdGlmIChjb21wb25lbnQgJiYgIWhhc19vd25lcihtZXRhZGF0YSwgY29tcG9uZW50KSkge1xuXHRcdGxldCBvcmlnaW5hbCA9IGdldF9vd25lcihtZXRhZGF0YSk7XG5cblx0XHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdFx0aWYgKG9yaWdpbmFsW0ZJTEVOQU1FXSAhPT0gY29tcG9uZW50W0ZJTEVOQU1FXSkge1xuXHRcdFx0Ly8gQHRzLWV4cGVjdC1lcnJvclxuXHRcdFx0dy5vd25lcnNoaXBfaW52YWxpZF9tdXRhdGlvbihjb21wb25lbnRbRklMRU5BTUVdLCBvcmlnaW5hbFtGSUxFTkFNRV0pO1xuXHRcdH0gZWxzZSB7XG5cdFx0XHR3Lm93bmVyc2hpcF9pbnZhbGlkX211dGF0aW9uKCk7XG5cdFx0fVxuXHR9XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBDb21wb25lbnRDb250ZXh0IH0gZnJvbSAnI2NsaWVudCcgKi9cblxuaW1wb3J0IHsgREVWIH0gZnJvbSAnZXNtLWVudic7XG5pbXBvcnQgeyBhZGRfb3duZXIgfSBmcm9tICcuL2Rldi9vd25lcnNoaXAuanMnO1xuaW1wb3J0IHsgbGlmZWN5Y2xlX291dHNpZGVfY29tcG9uZW50IH0gZnJvbSAnLi4vc2hhcmVkL2Vycm9ycy5qcyc7XG5pbXBvcnQgeyBzb3VyY2UgfSBmcm9tICcuL3JlYWN0aXZpdHkvc291cmNlcy5qcyc7XG5pbXBvcnQge1xuXHRhY3RpdmVfZWZmZWN0LFxuXHRhY3RpdmVfcmVhY3Rpb24sXG5cdHNldF9hY3RpdmVfZWZmZWN0LFxuXHRzZXRfYWN0aXZlX3JlYWN0aW9uLFxuXHR1bnRyYWNrXG59IGZyb20gJy4vcnVudGltZS5qcyc7XG5pbXBvcnQgeyBlZmZlY3QgfSBmcm9tICcuL3JlYWN0aXZpdHkvZWZmZWN0cy5qcyc7XG5pbXBvcnQgeyBsZWdhY3lfbW9kZV9mbGFnIH0gZnJvbSAnLi4vZmxhZ3MvaW5kZXguanMnO1xuXG4vKiogQHR5cGUge0NvbXBvbmVudENvbnRleHQgfCBudWxsfSAqL1xuZXhwb3J0IGxldCBjb21wb25lbnRfY29udGV4dCA9IG51bGw7XG5cbi8qKiBAcGFyYW0ge0NvbXBvbmVudENvbnRleHQgfCBudWxsfSBjb250ZXh0ICovXG5leHBvcnQgZnVuY3Rpb24gc2V0X2NvbXBvbmVudF9jb250ZXh0KGNvbnRleHQpIHtcblx0Y29tcG9uZW50X2NvbnRleHQgPSBjb250ZXh0O1xufVxuXG4vKipcbiAqIFRoZSBjdXJyZW50IGNvbXBvbmVudCBmdW5jdGlvbi4gRGlmZmVyZW50IGZyb20gY3VycmVudCBjb21wb25lbnQgY29udGV4dDpcbiAqIGBgYGh0bWxcbiAqIDwhLS0gQXBwLnN2ZWx0ZSAtLT5cbiAqIDxGb28+XG4gKiAgIDxCYXIgLz4gPCEtLSBjb250ZXh0ID09IEZvby5zdmVsdGUsIGZ1bmN0aW9uID09IEFwcC5zdmVsdGUgLS0+XG4gKiA8L0Zvbz5cbiAqIGBgYFxuICogQHR5cGUge0NvbXBvbmVudENvbnRleHRbJ2Z1bmN0aW9uJ119XG4gKi9cbmV4cG9ydCBsZXQgZGV2X2N1cnJlbnRfY29tcG9uZW50X2Z1bmN0aW9uID0gbnVsbDtcblxuLyoqIEBwYXJhbSB7Q29tcG9uZW50Q29udGV4dFsnZnVuY3Rpb24nXX0gZm4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzZXRfZGV2X2N1cnJlbnRfY29tcG9uZW50X2Z1bmN0aW9uKGZuKSB7XG5cdGRldl9jdXJyZW50X2NvbXBvbmVudF9mdW5jdGlvbiA9IGZuO1xufVxuXG4vKipcbiAqIFJldHJpZXZlcyB0aGUgY29udGV4dCB0aGF0IGJlbG9uZ3MgdG8gdGhlIGNsb3Nlc3QgcGFyZW50IGNvbXBvbmVudCB3aXRoIHRoZSBzcGVjaWZpZWQgYGtleWAuXG4gKiBNdXN0IGJlIGNhbGxlZCBkdXJpbmcgY29tcG9uZW50IGluaXRpYWxpc2F0aW9uLlxuICpcbiAqIEB0ZW1wbGF0ZSBUXG4gKiBAcGFyYW0ge2FueX0ga2V5XG4gKiBAcmV0dXJucyB7VH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGdldENvbnRleHQoa2V5KSB7XG5cdGNvbnN0IGNvbnRleHRfbWFwID0gZ2V0X29yX2luaXRfY29udGV4dF9tYXAoJ2dldENvbnRleHQnKTtcblx0Y29uc3QgcmVzdWx0ID0gLyoqIEB0eXBlIHtUfSAqLyAoY29udGV4dF9tYXAuZ2V0KGtleSkpO1xuXHRyZXR1cm4gcmVzdWx0O1xufVxuXG4vKipcbiAqIEFzc29jaWF0ZXMgYW4gYXJiaXRyYXJ5IGBjb250ZXh0YCBvYmplY3Qgd2l0aCB0aGUgY3VycmVudCBjb21wb25lbnQgYW5kIHRoZSBzcGVjaWZpZWQgYGtleWBcbiAqIGFuZCByZXR1cm5zIHRoYXQgb2JqZWN0LiBUaGUgY29udGV4dCBpcyB0aGVuIGF2YWlsYWJsZSB0byBjaGlsZHJlbiBvZiB0aGUgY29tcG9uZW50XG4gKiAoaW5jbHVkaW5nIHNsb3R0ZWQgY29udGVudCkgd2l0aCBgZ2V0Q29udGV4dGAuXG4gKlxuICogTGlrZSBsaWZlY3ljbGUgZnVuY3Rpb25zLCB0aGlzIG11c3QgYmUgY2FsbGVkIGR1cmluZyBjb21wb25lbnQgaW5pdGlhbGlzYXRpb24uXG4gKlxuICogQHRlbXBsYXRlIFRcbiAqIEBwYXJhbSB7YW55fSBrZXlcbiAqIEBwYXJhbSB7VH0gY29udGV4dFxuICogQHJldHVybnMge1R9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzZXRDb250ZXh0KGtleSwgY29udGV4dCkge1xuXHRjb25zdCBjb250ZXh0X21hcCA9IGdldF9vcl9pbml0X2NvbnRleHRfbWFwKCdzZXRDb250ZXh0Jyk7XG5cblx0aWYgKERFVikge1xuXHRcdC8vIFdoZW4gc3RhdGUgaXMgcHV0IGludG8gY29udGV4dCwgd2UgdHJlYXQgYXMgaWYgaXQncyBnbG9iYWwgZnJvbSBub3cgb24uXG5cdFx0Ly8gV2UgZG8gZm9yIHBlcmZvcm1hbmNlIHJlYXNvbnMgKGl0J3MgZm9yIGV4YW1wbGUgdmVyeSBleHBlbnNpdmUgdG8gY2FsbFxuXHRcdC8vIGdldENvbnRleHQgb24gYSBiaWcgb2JqZWN0IG1hbnkgdGltZXMgd2hlbiBwYXJ0IG9mIGEgbGlzdCBjb21wb25lbnQpXG5cdFx0Ly8gYW5kIGRhbmdlciBvZiBmYWxzZSBwb3NpdGl2ZXMuXG5cdFx0dW50cmFjaygoKSA9PiBhZGRfb3duZXIoY29udGV4dCwgbnVsbCwgdHJ1ZSkpO1xuXHR9XG5cblx0Y29udGV4dF9tYXAuc2V0KGtleSwgY29udGV4dCk7XG5cdHJldHVybiBjb250ZXh0O1xufVxuXG4vKipcbiAqIENoZWNrcyB3aGV0aGVyIGEgZ2l2ZW4gYGtleWAgaGFzIGJlZW4gc2V0IGluIHRoZSBjb250ZXh0IG9mIGEgcGFyZW50IGNvbXBvbmVudC5cbiAqIE11c3QgYmUgY2FsbGVkIGR1cmluZyBjb21wb25lbnQgaW5pdGlhbGlzYXRpb24uXG4gKlxuICogQHBhcmFtIHthbnl9IGtleVxuICogQHJldHVybnMge2Jvb2xlYW59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBoYXNDb250ZXh0KGtleSkge1xuXHRjb25zdCBjb250ZXh0X21hcCA9IGdldF9vcl9pbml0X2NvbnRleHRfbWFwKCdoYXNDb250ZXh0Jyk7XG5cdHJldHVybiBjb250ZXh0X21hcC5oYXMoa2V5KTtcbn1cblxuLyoqXG4gKiBSZXRyaWV2ZXMgdGhlIHdob2xlIGNvbnRleHQgbWFwIHRoYXQgYmVsb25ncyB0byB0aGUgY2xvc2VzdCBwYXJlbnQgY29tcG9uZW50LlxuICogTXVzdCBiZSBjYWxsZWQgZHVyaW5nIGNvbXBvbmVudCBpbml0aWFsaXNhdGlvbi4gVXNlZnVsLCBmb3IgZXhhbXBsZSwgaWYgeW91XG4gKiBwcm9ncmFtbWF0aWNhbGx5IGNyZWF0ZSBhIGNvbXBvbmVudCBhbmQgd2FudCB0byBwYXNzIHRoZSBleGlzdGluZyBjb250ZXh0IHRvIGl0LlxuICpcbiAqIEB0ZW1wbGF0ZSB7TWFwPGFueSwgYW55Pn0gW1Q9TWFwPGFueSwgYW55Pl1cbiAqIEByZXR1cm5zIHtUfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZ2V0QWxsQ29udGV4dHMoKSB7XG5cdGNvbnN0IGNvbnRleHRfbWFwID0gZ2V0X29yX2luaXRfY29udGV4dF9tYXAoJ2dldEFsbENvbnRleHRzJyk7XG5cdHJldHVybiAvKiogQHR5cGUge1R9ICovIChjb250ZXh0X21hcCk7XG59XG5cbi8qKlxuICogQHBhcmFtIHtSZWNvcmQ8c3RyaW5nLCB1bmtub3duPn0gcHJvcHNcbiAqIEBwYXJhbSB7YW55fSBydW5lc1xuICogQHBhcmFtIHtGdW5jdGlvbn0gW2ZuXVxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBwdXNoKHByb3BzLCBydW5lcyA9IGZhbHNlLCBmbikge1xuXHRjb21wb25lbnRfY29udGV4dCA9IHtcblx0XHRwOiBjb21wb25lbnRfY29udGV4dCxcblx0XHRjOiBudWxsLFxuXHRcdGU6IG51bGwsXG5cdFx0bTogZmFsc2UsXG5cdFx0czogcHJvcHMsXG5cdFx0eDogbnVsbCxcblx0XHRsOiBudWxsXG5cdH07XG5cblx0aWYgKGxlZ2FjeV9tb2RlX2ZsYWcgJiYgIXJ1bmVzKSB7XG5cdFx0Y29tcG9uZW50X2NvbnRleHQubCA9IHtcblx0XHRcdHM6IG51bGwsXG5cdFx0XHR1OiBudWxsLFxuXHRcdFx0cjE6IFtdLFxuXHRcdFx0cjI6IHNvdXJjZShmYWxzZSlcblx0XHR9O1xuXHR9XG5cblx0aWYgKERFVikge1xuXHRcdC8vIGNvbXBvbmVudCBmdW5jdGlvblxuXHRcdGNvbXBvbmVudF9jb250ZXh0LmZ1bmN0aW9uID0gZm47XG5cdFx0ZGV2X2N1cnJlbnRfY29tcG9uZW50X2Z1bmN0aW9uID0gZm47XG5cdH1cbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUge1JlY29yZDxzdHJpbmcsIGFueT59IFRcbiAqIEBwYXJhbSB7VH0gW2NvbXBvbmVudF1cbiAqIEByZXR1cm5zIHtUfVxuICovXG5leHBvcnQgZnVuY3Rpb24gcG9wKGNvbXBvbmVudCkge1xuXHRjb25zdCBjb250ZXh0X3N0YWNrX2l0ZW0gPSBjb21wb25lbnRfY29udGV4dDtcblx0aWYgKGNvbnRleHRfc3RhY2tfaXRlbSAhPT0gbnVsbCkge1xuXHRcdGlmIChjb21wb25lbnQgIT09IHVuZGVmaW5lZCkge1xuXHRcdFx0Y29udGV4dF9zdGFja19pdGVtLnggPSBjb21wb25lbnQ7XG5cdFx0fVxuXHRcdGNvbnN0IGNvbXBvbmVudF9lZmZlY3RzID0gY29udGV4dF9zdGFja19pdGVtLmU7XG5cdFx0aWYgKGNvbXBvbmVudF9lZmZlY3RzICE9PSBudWxsKSB7XG5cdFx0XHR2YXIgcHJldmlvdXNfZWZmZWN0ID0gYWN0aXZlX2VmZmVjdDtcblx0XHRcdHZhciBwcmV2aW91c19yZWFjdGlvbiA9IGFjdGl2ZV9yZWFjdGlvbjtcblx0XHRcdGNvbnRleHRfc3RhY2tfaXRlbS5lID0gbnVsbDtcblx0XHRcdHRyeSB7XG5cdFx0XHRcdGZvciAodmFyIGkgPSAwOyBpIDwgY29tcG9uZW50X2VmZmVjdHMubGVuZ3RoOyBpKyspIHtcblx0XHRcdFx0XHR2YXIgY29tcG9uZW50X2VmZmVjdCA9IGNvbXBvbmVudF9lZmZlY3RzW2ldO1xuXHRcdFx0XHRcdHNldF9hY3RpdmVfZWZmZWN0KGNvbXBvbmVudF9lZmZlY3QuZWZmZWN0KTtcblx0XHRcdFx0XHRzZXRfYWN0aXZlX3JlYWN0aW9uKGNvbXBvbmVudF9lZmZlY3QucmVhY3Rpb24pO1xuXHRcdFx0XHRcdGVmZmVjdChjb21wb25lbnRfZWZmZWN0LmZuKTtcblx0XHRcdFx0fVxuXHRcdFx0fSBmaW5hbGx5IHtcblx0XHRcdFx0c2V0X2FjdGl2ZV9lZmZlY3QocHJldmlvdXNfZWZmZWN0KTtcblx0XHRcdFx0c2V0X2FjdGl2ZV9yZWFjdGlvbihwcmV2aW91c19yZWFjdGlvbik7XG5cdFx0XHR9XG5cdFx0fVxuXHRcdGNvbXBvbmVudF9jb250ZXh0ID0gY29udGV4dF9zdGFja19pdGVtLnA7XG5cdFx0aWYgKERFVikge1xuXHRcdFx0ZGV2X2N1cnJlbnRfY29tcG9uZW50X2Z1bmN0aW9uID0gY29udGV4dF9zdGFja19pdGVtLnA/LmZ1bmN0aW9uID8/IG51bGw7XG5cdFx0fVxuXHRcdGNvbnRleHRfc3RhY2tfaXRlbS5tID0gdHJ1ZTtcblx0fVxuXHQvLyBNaWNyby1vcHRpbWl6YXRpb246IERvbid0IHNldCAuYSBhYm92ZSB0byB0aGUgZW1wdHkgb2JqZWN0XG5cdC8vIHNvIGl0IGNhbiBiZSBnYXJiYWdlLWNvbGxlY3RlZCB3aGVuIHRoZSByZXR1cm4gaGVyZSBpcyB1bnVzZWRcblx0cmV0dXJuIGNvbXBvbmVudCB8fCAvKiogQHR5cGUge1R9ICovICh7fSk7XG59XG5cbi8qKiBAcmV0dXJucyB7Ym9vbGVhbn0gKi9cbmV4cG9ydCBmdW5jdGlvbiBpc19ydW5lcygpIHtcblx0cmV0dXJuICFsZWdhY3lfbW9kZV9mbGFnIHx8IChjb21wb25lbnRfY29udGV4dCAhPT0gbnVsbCAmJiBjb21wb25lbnRfY29udGV4dC5sID09PSBudWxsKTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge3N0cmluZ30gbmFtZVxuICogQHJldHVybnMge01hcDx1bmtub3duLCB1bmtub3duPn1cbiAqL1xuZnVuY3Rpb24gZ2V0X29yX2luaXRfY29udGV4dF9tYXAobmFtZSkge1xuXHRpZiAoY29tcG9uZW50X2NvbnRleHQgPT09IG51bGwpIHtcblx0XHRsaWZlY3ljbGVfb3V0c2lkZV9jb21wb25lbnQobmFtZSk7XG5cdH1cblxuXHRyZXR1cm4gKGNvbXBvbmVudF9jb250ZXh0LmMgPz89IG5ldyBNYXAoZ2V0X3BhcmVudF9jb250ZXh0KGNvbXBvbmVudF9jb250ZXh0KSB8fCB1bmRlZmluZWQpKTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge0NvbXBvbmVudENvbnRleHR9IGNvbXBvbmVudF9jb250ZXh0XG4gKiBAcmV0dXJucyB7TWFwPHVua25vd24sIHVua25vd24+IHwgbnVsbH1cbiAqL1xuZnVuY3Rpb24gZ2V0X3BhcmVudF9jb250ZXh0KGNvbXBvbmVudF9jb250ZXh0KSB7XG5cdGxldCBwYXJlbnQgPSBjb21wb25lbnRfY29udGV4dC5wO1xuXHR3aGlsZSAocGFyZW50ICE9PSBudWxsKSB7XG5cdFx0Y29uc3QgY29udGV4dF9tYXAgPSBwYXJlbnQuYztcblx0XHRpZiAoY29udGV4dF9tYXAgIT09IG51bGwpIHtcblx0XHRcdHJldHVybiBjb250ZXh0X21hcDtcblx0XHR9XG5cdFx0cGFyZW50ID0gcGFyZW50LnA7XG5cdH1cblx0cmV0dXJuIG51bGw7XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBEZXJpdmVkLCBFZmZlY3QsIFJlYWN0aW9uLCBTb3VyY2UsIFZhbHVlIH0gZnJvbSAnI2NsaWVudCcgKi9cbmltcG9ydCB7IERFViB9IGZyb20gJ2VzbS1lbnYnO1xuaW1wb3J0IHtcblx0YWN0aXZlX3JlYWN0aW9uLFxuXHRhY3RpdmVfZWZmZWN0LFxuXHR1bnRyYWNrZWRfd3JpdGVzLFxuXHRnZXQsXG5cdHNjaGVkdWxlX2VmZmVjdCxcblx0c2V0X3VudHJhY2tlZF93cml0ZXMsXG5cdHNldF9zaWduYWxfc3RhdHVzLFxuXHR1bnRyYWNrLFxuXHRpbmNyZW1lbnRfd3JpdGVfdmVyc2lvbixcblx0dXBkYXRlX2VmZmVjdCxcblx0ZGVyaXZlZF9zb3VyY2VzLFxuXHRzZXRfZGVyaXZlZF9zb3VyY2VzLFxuXHRjaGVja19kaXJ0aW5lc3MsXG5cdHNldF9pc19mbHVzaGluZ19lZmZlY3QsXG5cdGlzX2ZsdXNoaW5nX2VmZmVjdCxcblx0dW50cmFja2luZ1xufSBmcm9tICcuLi9ydW50aW1lLmpzJztcbmltcG9ydCB7IGVxdWFscywgc2FmZV9lcXVhbHMgfSBmcm9tICcuL2VxdWFsaXR5LmpzJztcbmltcG9ydCB7XG5cdENMRUFOLFxuXHRERVJJVkVELFxuXHRESVJUWSxcblx0QlJBTkNIX0VGRkVDVCxcblx0SU5TUEVDVF9FRkZFQ1QsXG5cdFVOT1dORUQsXG5cdE1BWUJFX0RJUlRZLFxuXHRCTE9DS19FRkZFQ1QsXG5cdFJPT1RfRUZGRUNUXG59IGZyb20gJy4uL2NvbnN0YW50cy5qcyc7XG5pbXBvcnQgKiBhcyBlIGZyb20gJy4uL2Vycm9ycy5qcyc7XG5pbXBvcnQgeyBsZWdhY3lfbW9kZV9mbGFnLCB0cmFjaW5nX21vZGVfZmxhZyB9IGZyb20gJy4uLy4uL2ZsYWdzL2luZGV4LmpzJztcbmltcG9ydCB7IGdldF9zdGFjayB9IGZyb20gJy4uL2Rldi90cmFjaW5nLmpzJztcbmltcG9ydCB7IGNvbXBvbmVudF9jb250ZXh0LCBpc19ydW5lcyB9IGZyb20gJy4uL2NvbnRleHQuanMnO1xuXG5leHBvcnQgbGV0IGluc3BlY3RfZWZmZWN0cyA9IG5ldyBTZXQoKTtcblxuLyoqXG4gKiBAcGFyYW0ge1NldDxhbnk+fSB2XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzZXRfaW5zcGVjdF9lZmZlY3RzKHYpIHtcblx0aW5zcGVjdF9lZmZlY3RzID0gdjtcbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUgVlxuICogQHBhcmFtIHtWfSB2XG4gKiBAcGFyYW0ge0Vycm9yIHwgbnVsbH0gW3N0YWNrXVxuICogQHJldHVybnMge1NvdXJjZTxWPn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHNvdXJjZSh2LCBzdGFjaykge1xuXHQvKiogQHR5cGUge1ZhbHVlfSAqL1xuXHR2YXIgc2lnbmFsID0ge1xuXHRcdGY6IDAsIC8vIFRPRE8gaWRlYWxseSB3ZSBjb3VsZCBza2lwIHRoaXMgYWx0b2dldGhlciwgYnV0IGl0IGNhdXNlcyB0eXBlIGVycm9yc1xuXHRcdHYsXG5cdFx0cmVhY3Rpb25zOiBudWxsLFxuXHRcdGVxdWFscyxcblx0XHRydjogMCxcblx0XHR3djogMFxuXHR9O1xuXG5cdGlmIChERVYgJiYgdHJhY2luZ19tb2RlX2ZsYWcpIHtcblx0XHRzaWduYWwuY3JlYXRlZCA9IHN0YWNrID8/IGdldF9zdGFjaygnQ3JlYXRlZEF0Jyk7XG5cdFx0c2lnbmFsLmRlYnVnID0gbnVsbDtcblx0fVxuXG5cdHJldHVybiBzaWduYWw7XG59XG5cbi8qKlxuICogQHRlbXBsYXRlIFZcbiAqIEBwYXJhbSB7Vn0gdlxuICovXG5leHBvcnQgZnVuY3Rpb24gc3RhdGUodikge1xuXHRyZXR1cm4gcHVzaF9kZXJpdmVkX3NvdXJjZShzb3VyY2UodikpO1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0ge1Z9IGluaXRpYWxfdmFsdWVcbiAqIEBwYXJhbSB7Ym9vbGVhbn0gW2ltbXV0YWJsZV1cbiAqIEByZXR1cm5zIHtTb3VyY2U8Vj59XG4gKi9cbi8qI19fTk9fU0lERV9FRkZFQ1RTX18qL1xuZXhwb3J0IGZ1bmN0aW9uIG11dGFibGVfc291cmNlKGluaXRpYWxfdmFsdWUsIGltbXV0YWJsZSA9IGZhbHNlKSB7XG5cdGNvbnN0IHMgPSBzb3VyY2UoaW5pdGlhbF92YWx1ZSk7XG5cdGlmICghaW1tdXRhYmxlKSB7XG5cdFx0cy5lcXVhbHMgPSBzYWZlX2VxdWFscztcblx0fVxuXG5cdC8vIGJpbmQgdGhlIHNpZ25hbCB0byB0aGUgY29tcG9uZW50IGNvbnRleHQsIGluIGNhc2Ugd2UgbmVlZCB0b1xuXHQvLyB0cmFjayB1cGRhdGVzIHRvIHRyaWdnZXIgYmVmb3JlVXBkYXRlL2FmdGVyVXBkYXRlIGNhbGxiYWNrc1xuXHRpZiAobGVnYWN5X21vZGVfZmxhZyAmJiBjb21wb25lbnRfY29udGV4dCAhPT0gbnVsbCAmJiBjb21wb25lbnRfY29udGV4dC5sICE9PSBudWxsKSB7XG5cdFx0KGNvbXBvbmVudF9jb250ZXh0LmwucyA/Pz0gW10pLnB1c2gocyk7XG5cdH1cblxuXHRyZXR1cm4gcztcbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUgVlxuICogQHBhcmFtIHtWfSB2XG4gKiBAcGFyYW0ge2Jvb2xlYW59IFtpbW11dGFibGVdXG4gKiBAcmV0dXJucyB7U291cmNlPFY+fVxuICovXG5leHBvcnQgZnVuY3Rpb24gbXV0YWJsZV9zdGF0ZSh2LCBpbW11dGFibGUgPSBmYWxzZSkge1xuXHRyZXR1cm4gcHVzaF9kZXJpdmVkX3NvdXJjZShtdXRhYmxlX3NvdXJjZSh2LCBpbW11dGFibGUpKTtcbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUgVlxuICogQHBhcmFtIHtTb3VyY2U8Vj59IHNvdXJjZVxuICovXG4vKiNfX05PX1NJREVfRUZGRUNUU19fKi9cbmZ1bmN0aW9uIHB1c2hfZGVyaXZlZF9zb3VyY2Uoc291cmNlKSB7XG5cdGlmIChhY3RpdmVfcmVhY3Rpb24gIT09IG51bGwgJiYgIXVudHJhY2tpbmcgJiYgKGFjdGl2ZV9yZWFjdGlvbi5mICYgREVSSVZFRCkgIT09IDApIHtcblx0XHRpZiAoZGVyaXZlZF9zb3VyY2VzID09PSBudWxsKSB7XG5cdFx0XHRzZXRfZGVyaXZlZF9zb3VyY2VzKFtzb3VyY2VdKTtcblx0XHR9IGVsc2Uge1xuXHRcdFx0ZGVyaXZlZF9zb3VyY2VzLnB1c2goc291cmNlKTtcblx0XHR9XG5cdH1cblxuXHRyZXR1cm4gc291cmNlO1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0ge1ZhbHVlPFY+fSBzb3VyY2VcbiAqIEBwYXJhbSB7Vn0gdmFsdWVcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIG11dGF0ZShzb3VyY2UsIHZhbHVlKSB7XG5cdHNldChcblx0XHRzb3VyY2UsXG5cdFx0dW50cmFjaygoKSA9PiBnZXQoc291cmNlKSlcblx0KTtcblx0cmV0dXJuIHZhbHVlO1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0ge1NvdXJjZTxWPn0gc291cmNlXG4gKiBAcGFyYW0ge1Z9IHZhbHVlXG4gKiBAcmV0dXJucyB7Vn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHNldChzb3VyY2UsIHZhbHVlKSB7XG5cdGlmIChcblx0XHRhY3RpdmVfcmVhY3Rpb24gIT09IG51bGwgJiZcblx0XHQhdW50cmFja2luZyAmJlxuXHRcdGlzX3J1bmVzKCkgJiZcblx0XHQoYWN0aXZlX3JlYWN0aW9uLmYgJiAoREVSSVZFRCB8IEJMT0NLX0VGRkVDVCkpICE9PSAwICYmXG5cdFx0Ly8gSWYgdGhlIHNvdXJjZSB3YXMgY3JlYXRlZCBsb2NhbGx5IHdpdGhpbiB0aGUgY3VycmVudCBkZXJpdmVkLCB0aGVuXG5cdFx0Ly8gd2UgYWxsb3cgdGhlIG11dGF0aW9uLlxuXHRcdChkZXJpdmVkX3NvdXJjZXMgPT09IG51bGwgfHwgIWRlcml2ZWRfc291cmNlcy5pbmNsdWRlcyhzb3VyY2UpKVxuXHQpIHtcblx0XHRlLnN0YXRlX3Vuc2FmZV9tdXRhdGlvbigpO1xuXHR9XG5cblx0cmV0dXJuIGludGVybmFsX3NldChzb3VyY2UsIHZhbHVlKTtcbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUgVlxuICogQHBhcmFtIHtTb3VyY2U8Vj59IHNvdXJjZVxuICogQHBhcmFtIHtWfSB2YWx1ZVxuICogQHJldHVybnMge1Z9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBpbnRlcm5hbF9zZXQoc291cmNlLCB2YWx1ZSkge1xuXHRpZiAoIXNvdXJjZS5lcXVhbHModmFsdWUpKSB7XG5cdFx0dmFyIG9sZF92YWx1ZSA9IHNvdXJjZS52O1xuXHRcdHNvdXJjZS52ID0gdmFsdWU7XG5cdFx0c291cmNlLnd2ID0gaW5jcmVtZW50X3dyaXRlX3ZlcnNpb24oKTtcblxuXHRcdGlmIChERVYgJiYgdHJhY2luZ19tb2RlX2ZsYWcpIHtcblx0XHRcdHNvdXJjZS51cGRhdGVkID0gZ2V0X3N0YWNrKCdVcGRhdGVkQXQnKTtcblx0XHRcdGlmIChhY3RpdmVfZWZmZWN0ICE9IG51bGwpIHtcblx0XHRcdFx0c291cmNlLnRyYWNlX25lZWRfaW5jcmVhc2UgPSB0cnVlO1xuXHRcdFx0XHRzb3VyY2UudHJhY2VfdiA/Pz0gb2xkX3ZhbHVlO1xuXHRcdFx0fVxuXHRcdH1cblxuXHRcdG1hcmtfcmVhY3Rpb25zKHNvdXJjZSwgRElSVFkpO1xuXG5cdFx0Ly8gSXQncyBwb3NzaWJsZSB0aGF0IHRoZSBjdXJyZW50IHJlYWN0aW9uIG1pZ2h0IG5vdCBoYXZlIHVwLXRvLWRhdGUgZGVwZW5kZW5jaWVzXG5cdFx0Ly8gd2hpbHN0IGl0J3MgYWN0aXZlbHkgcnVubmluZy4gU28gaW4gdGhlIGNhc2Ugb2YgZW5zdXJpbmcgaXQgcmVnaXN0ZXJzIHRoZSByZWFjdGlvblxuXHRcdC8vIHByb3Blcmx5IGZvciBpdHNlbGYsIHdlIG5lZWQgdG8gZW5zdXJlIHRoZSBjdXJyZW50IGVmZmVjdCBhY3R1YWxseSBnZXRzXG5cdFx0Ly8gc2NoZWR1bGVkLiBpLmU6IGAkZWZmZWN0KCgpID0+IHgrKylgXG5cdFx0aWYgKFxuXHRcdFx0aXNfcnVuZXMoKSAmJlxuXHRcdFx0YWN0aXZlX2VmZmVjdCAhPT0gbnVsbCAmJlxuXHRcdFx0KGFjdGl2ZV9lZmZlY3QuZiAmIENMRUFOKSAhPT0gMCAmJlxuXHRcdFx0KGFjdGl2ZV9lZmZlY3QuZiAmIChCUkFOQ0hfRUZGRUNUIHwgUk9PVF9FRkZFQ1QpKSA9PT0gMFxuXHRcdCkge1xuXHRcdFx0aWYgKHVudHJhY2tlZF93cml0ZXMgPT09IG51bGwpIHtcblx0XHRcdFx0c2V0X3VudHJhY2tlZF93cml0ZXMoW3NvdXJjZV0pO1xuXHRcdFx0fSBlbHNlIHtcblx0XHRcdFx0dW50cmFja2VkX3dyaXRlcy5wdXNoKHNvdXJjZSk7XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0aWYgKERFViAmJiBpbnNwZWN0X2VmZmVjdHMuc2l6ZSA+IDApIHtcblx0XHRcdGNvbnN0IGluc3BlY3RzID0gQXJyYXkuZnJvbShpbnNwZWN0X2VmZmVjdHMpO1xuXHRcdFx0dmFyIHByZXZpb3VzbHlfZmx1c2hpbmdfZWZmZWN0ID0gaXNfZmx1c2hpbmdfZWZmZWN0O1xuXHRcdFx0c2V0X2lzX2ZsdXNoaW5nX2VmZmVjdCh0cnVlKTtcblx0XHRcdHRyeSB7XG5cdFx0XHRcdGZvciAoY29uc3QgZWZmZWN0IG9mIGluc3BlY3RzKSB7XG5cdFx0XHRcdFx0Ly8gTWFyayBjbGVhbiBpbnNwZWN0LWVmZmVjdHMgYXMgbWF5YmUgZGlydHkgYW5kIHRoZW4gY2hlY2sgdGhlaXIgZGlydGluZXNzXG5cdFx0XHRcdFx0Ly8gaW5zdGVhZCBvZiBqdXN0IHVwZGF0aW5nIHRoZSBlZmZlY3RzIC0gdGhpcyB3YXkgd2UgYXZvaWQgb3ZlcmZpcmluZy5cblx0XHRcdFx0XHRpZiAoKGVmZmVjdC5mICYgQ0xFQU4pICE9PSAwKSB7XG5cdFx0XHRcdFx0XHRzZXRfc2lnbmFsX3N0YXR1cyhlZmZlY3QsIE1BWUJFX0RJUlRZKTtcblx0XHRcdFx0XHR9XG5cdFx0XHRcdFx0aWYgKGNoZWNrX2RpcnRpbmVzcyhlZmZlY3QpKSB7XG5cdFx0XHRcdFx0XHR1cGRhdGVfZWZmZWN0KGVmZmVjdCk7XG5cdFx0XHRcdFx0fVxuXHRcdFx0XHR9XG5cdFx0XHR9IGZpbmFsbHkge1xuXHRcdFx0XHRzZXRfaXNfZmx1c2hpbmdfZWZmZWN0KHByZXZpb3VzbHlfZmx1c2hpbmdfZWZmZWN0KTtcblx0XHRcdH1cblx0XHRcdGluc3BlY3RfZWZmZWN0cy5jbGVhcigpO1xuXHRcdH1cblx0fVxuXG5cdHJldHVybiB2YWx1ZTtcbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUge251bWJlciB8IGJpZ2ludH0gVFxuICogQHBhcmFtIHtTb3VyY2U8VD59IHNvdXJjZVxuICogQHBhcmFtIHsxIHwgLTF9IFtkXVxuICogQHJldHVybnMge1R9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiB1cGRhdGUoc291cmNlLCBkID0gMSkge1xuXHR2YXIgdmFsdWUgPSBnZXQoc291cmNlKTtcblx0dmFyIHJlc3VsdCA9IGQgPT09IDEgPyB2YWx1ZSsrIDogdmFsdWUtLTtcblxuXHRzZXQoc291cmNlLCB2YWx1ZSk7XG5cblx0Ly8gQHRzLWV4cGVjdC1lcnJvclxuXHRyZXR1cm4gcmVzdWx0O1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSB7bnVtYmVyIHwgYmlnaW50fSBUXG4gKiBAcGFyYW0ge1NvdXJjZTxUPn0gc291cmNlXG4gKiBAcGFyYW0gezEgfCAtMX0gW2RdXG4gKiBAcmV0dXJucyB7VH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHVwZGF0ZV9wcmUoc291cmNlLCBkID0gMSkge1xuXHR2YXIgdmFsdWUgPSBnZXQoc291cmNlKTtcblxuXHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdHJldHVybiBzZXQoc291cmNlLCBkID09PSAxID8gKyt2YWx1ZSA6IC0tdmFsdWUpO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7VmFsdWV9IHNpZ25hbFxuICogQHBhcmFtIHtudW1iZXJ9IHN0YXR1cyBzaG91bGQgYmUgRElSVFkgb3IgTUFZQkVfRElSVFlcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5mdW5jdGlvbiBtYXJrX3JlYWN0aW9ucyhzaWduYWwsIHN0YXR1cykge1xuXHR2YXIgcmVhY3Rpb25zID0gc2lnbmFsLnJlYWN0aW9ucztcblx0aWYgKHJlYWN0aW9ucyA9PT0gbnVsbCkgcmV0dXJuO1xuXG5cdHZhciBydW5lcyA9IGlzX3J1bmVzKCk7XG5cdHZhciBsZW5ndGggPSByZWFjdGlvbnMubGVuZ3RoO1xuXG5cdGZvciAodmFyIGkgPSAwOyBpIDwgbGVuZ3RoOyBpKyspIHtcblx0XHR2YXIgcmVhY3Rpb24gPSByZWFjdGlvbnNbaV07XG5cdFx0dmFyIGZsYWdzID0gcmVhY3Rpb24uZjtcblxuXHRcdC8vIFNraXAgYW55IGVmZmVjdHMgdGhhdCBhcmUgYWxyZWFkeSBkaXJ0eVxuXHRcdGlmICgoZmxhZ3MgJiBESVJUWSkgIT09IDApIGNvbnRpbnVlO1xuXG5cdFx0Ly8gSW4gbGVnYWN5IG1vZGUsIHNraXAgdGhlIGN1cnJlbnQgZWZmZWN0IHRvIHByZXZlbnQgaW5maW5pdGUgbG9vcHNcblx0XHRpZiAoIXJ1bmVzICYmIHJlYWN0aW9uID09PSBhY3RpdmVfZWZmZWN0KSBjb250aW51ZTtcblxuXHRcdC8vIEluc3BlY3QgZWZmZWN0cyBuZWVkIHRvIHJ1biBpbW1lZGlhdGVseSwgc28gdGhhdCB0aGUgc3RhY2sgdHJhY2UgbWFrZXMgc2Vuc2Vcblx0XHRpZiAoREVWICYmIChmbGFncyAmIElOU1BFQ1RfRUZGRUNUKSAhPT0gMCkge1xuXHRcdFx0aW5zcGVjdF9lZmZlY3RzLmFkZChyZWFjdGlvbik7XG5cdFx0XHRjb250aW51ZTtcblx0XHR9XG5cblx0XHRzZXRfc2lnbmFsX3N0YXR1cyhyZWFjdGlvbiwgc3RhdHVzKTtcblxuXHRcdC8vIElmIHRoZSBzaWduYWwgYSkgd2FzIHByZXZpb3VzbHkgY2xlYW4gb3IgYikgaXMgYW4gdW5vd25lZCBkZXJpdmVkLCB0aGVuIG1hcmsgaXRcblx0XHRpZiAoKGZsYWdzICYgKENMRUFOIHwgVU5PV05FRCkpICE9PSAwKSB7XG5cdFx0XHRpZiAoKGZsYWdzICYgREVSSVZFRCkgIT09IDApIHtcblx0XHRcdFx0bWFya19yZWFjdGlvbnMoLyoqIEB0eXBlIHtEZXJpdmVkfSAqLyAocmVhY3Rpb24pLCBNQVlCRV9ESVJUWSk7XG5cdFx0XHR9IGVsc2Uge1xuXHRcdFx0XHRzY2hlZHVsZV9lZmZlY3QoLyoqIEB0eXBlIHtFZmZlY3R9ICovIChyZWFjdGlvbikpO1xuXHRcdFx0fVxuXHRcdH1cblx0fVxufVxuIiwgIi8qKiBAaW1wb3J0IHsgVGVtcGxhdGVOb2RlIH0gZnJvbSAnI2NsaWVudCcgKi9cblxuaW1wb3J0IHtcblx0SFlEUkFUSU9OX0VORCxcblx0SFlEUkFUSU9OX0VSUk9SLFxuXHRIWURSQVRJT05fU1RBUlQsXG5cdEhZRFJBVElPTl9TVEFSVF9FTFNFXG59IGZyb20gJy4uLy4uLy4uL2NvbnN0YW50cy5qcyc7XG5pbXBvcnQgKiBhcyB3IGZyb20gJy4uL3dhcm5pbmdzLmpzJztcbmltcG9ydCB7IGdldF9uZXh0X3NpYmxpbmcgfSBmcm9tICcuL29wZXJhdGlvbnMuanMnO1xuXG4vKipcbiAqIFVzZSB0aGlzIHZhcmlhYmxlIHRvIGd1YXJkIGV2ZXJ5dGhpbmcgcmVsYXRlZCB0byBoeWRyYXRpb24gY29kZSBzbyBpdCBjYW4gYmUgdHJlZXNoYWtlbiBvdXRcbiAqIGlmIHRoZSB1c2VyIGRvZXNuJ3QgdXNlIHRoZSBgaHlkcmF0ZWAgbWV0aG9kIGFuZCB0aGVzZSBjb2RlIHBhdGhzIGFyZSB0aGVyZWZvcmUgbm90IG5lZWRlZC5cbiAqL1xuZXhwb3J0IGxldCBoeWRyYXRpbmcgPSBmYWxzZTtcblxuLyoqIEBwYXJhbSB7Ym9vbGVhbn0gdmFsdWUgKi9cbmV4cG9ydCBmdW5jdGlvbiBzZXRfaHlkcmF0aW5nKHZhbHVlKSB7XG5cdGh5ZHJhdGluZyA9IHZhbHVlO1xufVxuXG4vKipcbiAqIFRoZSBub2RlIHRoYXQgaXMgY3VycmVudGx5IGJlaW5nIGh5ZHJhdGVkLiBUaGlzIHN0YXJ0cyBvdXQgYXMgdGhlIGZpcnN0IG5vZGUgaW5zaWRlIHRoZSBvcGVuaW5nXG4gKiA8IS0tWy0tPiBjb21tZW50LCBhbmQgdXBkYXRlcyBlYWNoIHRpbWUgYSBjb21wb25lbnQgY2FsbHMgYCQuY2hpbGQoLi4uKWAgb3IgYCQuc2libGluZyguLi4pYC5cbiAqIFdoZW4gZW50ZXJpbmcgYSBibG9jayAoZS5nLiBgeyNpZiAuLi59YCksIGBoeWRyYXRlX25vZGVgIGlzIHRoZSBibG9jayBvcGVuaW5nIGNvbW1lbnQ7IGJ5IHRoZVxuICogdGltZSB3ZSBsZWF2ZSB0aGUgYmxvY2sgaXQgaXMgdGhlIGNsb3NpbmcgY29tbWVudCwgd2hpY2ggc2VydmVzIGFzIHRoZSBibG9jaydzIGFuY2hvci5cbiAqIEB0eXBlIHtUZW1wbGF0ZU5vZGV9XG4gKi9cbmV4cG9ydCBsZXQgaHlkcmF0ZV9ub2RlO1xuXG4vKiogQHBhcmFtIHtUZW1wbGF0ZU5vZGV9IG5vZGUgKi9cbmV4cG9ydCBmdW5jdGlvbiBzZXRfaHlkcmF0ZV9ub2RlKG5vZGUpIHtcblx0aWYgKG5vZGUgPT09IG51bGwpIHtcblx0XHR3Lmh5ZHJhdGlvbl9taXNtYXRjaCgpO1xuXHRcdHRocm93IEhZRFJBVElPTl9FUlJPUjtcblx0fVxuXG5cdHJldHVybiAoaHlkcmF0ZV9ub2RlID0gbm9kZSk7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBoeWRyYXRlX25leHQoKSB7XG5cdHJldHVybiBzZXRfaHlkcmF0ZV9ub2RlKC8qKiBAdHlwZSB7VGVtcGxhdGVOb2RlfSAqLyAoZ2V0X25leHRfc2libGluZyhoeWRyYXRlX25vZGUpKSk7XG59XG5cbi8qKiBAcGFyYW0ge1RlbXBsYXRlTm9kZX0gbm9kZSAqL1xuZXhwb3J0IGZ1bmN0aW9uIHJlc2V0KG5vZGUpIHtcblx0aWYgKCFoeWRyYXRpbmcpIHJldHVybjtcblxuXHQvLyBJZiB0aGUgbm9kZSBoYXMgcmVtYWluaW5nIHNpYmxpbmdzLCBzb21ldGhpbmcgaGFzIGdvbmUgd3Jvbmdcblx0aWYgKGdldF9uZXh0X3NpYmxpbmcoaHlkcmF0ZV9ub2RlKSAhPT0gbnVsbCkge1xuXHRcdHcuaHlkcmF0aW9uX21pc21hdGNoKCk7XG5cdFx0dGhyb3cgSFlEUkFUSU9OX0VSUk9SO1xuXHR9XG5cblx0aHlkcmF0ZV9ub2RlID0gbm9kZTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge0hUTUxUZW1wbGF0ZUVsZW1lbnR9IHRlbXBsYXRlXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBoeWRyYXRlX3RlbXBsYXRlKHRlbXBsYXRlKSB7XG5cdGlmIChoeWRyYXRpbmcpIHtcblx0XHQvLyBAdHMtZXhwZWN0LWVycm9yIFRlbXBsYXRlTm9kZSBkb2Vzbid0IGluY2x1ZGUgRG9jdW1lbnRGcmFnbWVudCwgYnV0IGl0J3MgYWN0dWFsbHkgZmluZVxuXHRcdGh5ZHJhdGVfbm9kZSA9IHRlbXBsYXRlLmNvbnRlbnQ7XG5cdH1cbn1cblxuZXhwb3J0IGZ1bmN0aW9uIG5leHQoY291bnQgPSAxKSB7XG5cdGlmIChoeWRyYXRpbmcpIHtcblx0XHR2YXIgaSA9IGNvdW50O1xuXHRcdHZhciBub2RlID0gaHlkcmF0ZV9ub2RlO1xuXG5cdFx0d2hpbGUgKGktLSkge1xuXHRcdFx0bm9kZSA9IC8qKiBAdHlwZSB7VGVtcGxhdGVOb2RlfSAqLyAoZ2V0X25leHRfc2libGluZyhub2RlKSk7XG5cdFx0fVxuXG5cdFx0aHlkcmF0ZV9ub2RlID0gbm9kZTtcblx0fVxufVxuXG4vKipcbiAqIFJlbW92ZXMgYWxsIG5vZGVzIHN0YXJ0aW5nIGF0IGBoeWRyYXRlX25vZGVgIHVwIHVudGlsIHRoZSBuZXh0IGh5ZHJhdGlvbiBlbmQgY29tbWVudFxuICovXG5leHBvcnQgZnVuY3Rpb24gcmVtb3ZlX25vZGVzKCkge1xuXHR2YXIgZGVwdGggPSAwO1xuXHR2YXIgbm9kZSA9IGh5ZHJhdGVfbm9kZTtcblxuXHR3aGlsZSAodHJ1ZSkge1xuXHRcdGlmIChub2RlLm5vZGVUeXBlID09PSA4KSB7XG5cdFx0XHR2YXIgZGF0YSA9IC8qKiBAdHlwZSB7Q29tbWVudH0gKi8gKG5vZGUpLmRhdGE7XG5cblx0XHRcdGlmIChkYXRhID09PSBIWURSQVRJT05fRU5EKSB7XG5cdFx0XHRcdGlmIChkZXB0aCA9PT0gMCkgcmV0dXJuIG5vZGU7XG5cdFx0XHRcdGRlcHRoIC09IDE7XG5cdFx0XHR9IGVsc2UgaWYgKGRhdGEgPT09IEhZRFJBVElPTl9TVEFSVCB8fCBkYXRhID09PSBIWURSQVRJT05fU1RBUlRfRUxTRSkge1xuXHRcdFx0XHRkZXB0aCArPSAxO1xuXHRcdFx0fVxuXHRcdH1cblxuXHRcdHZhciBuZXh0ID0gLyoqIEB0eXBlIHtUZW1wbGF0ZU5vZGV9ICovIChnZXRfbmV4dF9zaWJsaW5nKG5vZGUpKTtcblx0XHRub2RlLnJlbW92ZSgpO1xuXHRcdG5vZGUgPSBuZXh0O1xuXHR9XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBQcm94eU1ldGFkYXRhLCBTb3VyY2UgfSBmcm9tICcjY2xpZW50JyAqL1xuaW1wb3J0IHsgREVWIH0gZnJvbSAnZXNtLWVudic7XG5pbXBvcnQgeyBnZXQsIGFjdGl2ZV9lZmZlY3QgfSBmcm9tICcuL3J1bnRpbWUuanMnO1xuaW1wb3J0IHsgY29tcG9uZW50X2NvbnRleHQgfSBmcm9tICcuL2NvbnRleHQuanMnO1xuaW1wb3J0IHtcblx0YXJyYXlfcHJvdG90eXBlLFxuXHRnZXRfZGVzY3JpcHRvcixcblx0Z2V0X3Byb3RvdHlwZV9vZixcblx0aXNfYXJyYXksXG5cdG9iamVjdF9wcm90b3R5cGVcbn0gZnJvbSAnLi4vc2hhcmVkL3V0aWxzLmpzJztcbmltcG9ydCB7IGNoZWNrX293bmVyc2hpcCwgd2lkZW5fb3duZXJzaGlwIH0gZnJvbSAnLi9kZXYvb3duZXJzaGlwLmpzJztcbmltcG9ydCB7IHNvdXJjZSwgc2V0IH0gZnJvbSAnLi9yZWFjdGl2aXR5L3NvdXJjZXMuanMnO1xuaW1wb3J0IHsgU1RBVEVfU1lNQk9MLCBTVEFURV9TWU1CT0xfTUVUQURBVEEgfSBmcm9tICcuL2NvbnN0YW50cy5qcyc7XG5pbXBvcnQgeyBVTklOSVRJQUxJWkVEIH0gZnJvbSAnLi4vLi4vY29uc3RhbnRzLmpzJztcbmltcG9ydCAqIGFzIGUgZnJvbSAnLi9lcnJvcnMuanMnO1xuaW1wb3J0IHsgZ2V0X3N0YWNrIH0gZnJvbSAnLi9kZXYvdHJhY2luZy5qcyc7XG5pbXBvcnQgeyB0cmFjaW5nX21vZGVfZmxhZyB9IGZyb20gJy4uL2ZsYWdzL2luZGV4LmpzJztcblxuLyoqXG4gKiBAdGVtcGxhdGUgVFxuICogQHBhcmFtIHtUfSB2YWx1ZVxuICogQHBhcmFtIHtQcm94eU1ldGFkYXRhIHwgbnVsbH0gW3BhcmVudF1cbiAqIEBwYXJhbSB7U291cmNlPFQ+fSBbcHJldl0gZGV2IG1vZGUgb25seVxuICogQHJldHVybnMge1R9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBwcm94eSh2YWx1ZSwgcGFyZW50ID0gbnVsbCwgcHJldikge1xuXHQvKiogQHR5cGUge0Vycm9yIHwgbnVsbH0gKi9cblx0dmFyIHN0YWNrID0gbnVsbDtcblx0aWYgKERFViAmJiB0cmFjaW5nX21vZGVfZmxhZykge1xuXHRcdHN0YWNrID0gZ2V0X3N0YWNrKCdDcmVhdGVkQXQnKTtcblx0fVxuXHQvLyBpZiBub24tcHJveHlhYmxlLCBvciBpcyBhbHJlYWR5IGEgcHJveHksIHJldHVybiBgdmFsdWVgXG5cdGlmICh0eXBlb2YgdmFsdWUgIT09ICdvYmplY3QnIHx8IHZhbHVlID09PSBudWxsIHx8IFNUQVRFX1NZTUJPTCBpbiB2YWx1ZSkge1xuXHRcdHJldHVybiB2YWx1ZTtcblx0fVxuXG5cdGNvbnN0IHByb3RvdHlwZSA9IGdldF9wcm90b3R5cGVfb2YodmFsdWUpO1xuXG5cdGlmIChwcm90b3R5cGUgIT09IG9iamVjdF9wcm90b3R5cGUgJiYgcHJvdG90eXBlICE9PSBhcnJheV9wcm90b3R5cGUpIHtcblx0XHRyZXR1cm4gdmFsdWU7XG5cdH1cblxuXHQvKiogQHR5cGUge01hcDxhbnksIFNvdXJjZTxhbnk+Pn0gKi9cblx0dmFyIHNvdXJjZXMgPSBuZXcgTWFwKCk7XG5cdHZhciBpc19wcm94aWVkX2FycmF5ID0gaXNfYXJyYXkodmFsdWUpO1xuXHR2YXIgdmVyc2lvbiA9IHNvdXJjZSgwKTtcblxuXHRpZiAoaXNfcHJveGllZF9hcnJheSkge1xuXHRcdC8vIFdlIG5lZWQgdG8gY3JlYXRlIHRoZSBsZW5ndGggc291cmNlIGVhZ2VybHkgdG8gZW5zdXJlIHRoYXRcblx0XHQvLyBtdXRhdGlvbnMgdG8gdGhlIGFycmF5IGFyZSBwcm9wZXJseSBzeW5jZWQgd2l0aCBvdXIgcHJveHlcblx0XHRzb3VyY2VzLnNldCgnbGVuZ3RoJywgc291cmNlKC8qKiBAdHlwZSB7YW55W119ICovICh2YWx1ZSkubGVuZ3RoLCBzdGFjaykpO1xuXHR9XG5cblx0LyoqIEB0eXBlIHtQcm94eU1ldGFkYXRhfSAqL1xuXHR2YXIgbWV0YWRhdGE7XG5cblx0aWYgKERFVikge1xuXHRcdG1ldGFkYXRhID0ge1xuXHRcdFx0cGFyZW50LFxuXHRcdFx0b3duZXJzOiBudWxsXG5cdFx0fTtcblxuXHRcdGlmIChwcmV2KSB7XG5cdFx0XHQvLyBSZXVzZSBvd25lcnMgZnJvbSBwcmV2aW91cyBzdGF0ZTsgbmVjZXNzYXJ5IGJlY2F1c2UgcmVhc3NpZ25tZW50IGlzIG5vdCBndWFyYW50ZWVkIHRvIGhhdmUgY29ycmVjdCBjb21wb25lbnQgY29udGV4dC5cblx0XHRcdC8vIElmIG5vIHByZXZpb3VzIHByb3h5IGV4aXN0cyB3ZSBwbGF5IGl0IHNhZmUgYW5kIGFzc3VtZSBvd25lcmxlc3Mgc3RhdGVcblx0XHRcdC8vIEB0cy1leHBlY3QtZXJyb3Jcblx0XHRcdGNvbnN0IHByZXZfb3duZXJzID0gcHJldi52Py5bU1RBVEVfU1lNQk9MX01FVEFEQVRBXT8ub3duZXJzO1xuXHRcdFx0bWV0YWRhdGEub3duZXJzID0gcHJldl9vd25lcnMgPyBuZXcgU2V0KHByZXZfb3duZXJzKSA6IG51bGw7XG5cdFx0fSBlbHNlIHtcblx0XHRcdG1ldGFkYXRhLm93bmVycyA9XG5cdFx0XHRcdHBhcmVudCA9PT0gbnVsbFxuXHRcdFx0XHRcdD8gY29tcG9uZW50X2NvbnRleHQgIT09IG51bGxcblx0XHRcdFx0XHRcdD8gbmV3IFNldChbY29tcG9uZW50X2NvbnRleHQuZnVuY3Rpb25dKVxuXHRcdFx0XHRcdFx0OiBudWxsXG5cdFx0XHRcdFx0OiBuZXcgU2V0KCk7XG5cdFx0fVxuXHR9XG5cblx0cmV0dXJuIG5ldyBQcm94eSgvKiogQHR5cGUge2FueX0gKi8gKHZhbHVlKSwge1xuXHRcdGRlZmluZVByb3BlcnR5KF8sIHByb3AsIGRlc2NyaXB0b3IpIHtcblx0XHRcdGlmIChcblx0XHRcdFx0ISgndmFsdWUnIGluIGRlc2NyaXB0b3IpIHx8XG5cdFx0XHRcdGRlc2NyaXB0b3IuY29uZmlndXJhYmxlID09PSBmYWxzZSB8fFxuXHRcdFx0XHRkZXNjcmlwdG9yLmVudW1lcmFibGUgPT09IGZhbHNlIHx8XG5cdFx0XHRcdGRlc2NyaXB0b3Iud3JpdGFibGUgPT09IGZhbHNlXG5cdFx0XHQpIHtcblx0XHRcdFx0Ly8gd2UgZGlzYWxsb3cgbm9uLWJhc2ljIGRlc2NyaXB0b3JzLCBiZWNhdXNlIHVubGVzcyB0aGV5IGFyZSBhcHBsaWVkIHRvIHRoZVxuXHRcdFx0XHQvLyB0YXJnZXQgb2JqZWN0IFx1MjAxNCB3aGljaCB3ZSBhdm9pZCwgc28gdGhhdCBzdGF0ZSBjYW4gYmUgZm9ya2VkIFx1MjAxNCB3ZSB3aWxsIHJ1blxuXHRcdFx0XHQvLyBhZm91bCBvZiB0aGUgdmFyaW91cyBpbnZhcmlhbnRzXG5cdFx0XHRcdC8vIGh0dHBzOi8vZGV2ZWxvcGVyLm1vemlsbGEub3JnL2VuLVVTL2RvY3MvV2ViL0phdmFTY3JpcHQvUmVmZXJlbmNlL0dsb2JhbF9PYmplY3RzL1Byb3h5L1Byb3h5L2dldE93blByb3BlcnR5RGVzY3JpcHRvciNpbnZhcmlhbnRzXG5cdFx0XHRcdGUuc3RhdGVfZGVzY3JpcHRvcnNfZml4ZWQoKTtcblx0XHRcdH1cblxuXHRcdFx0dmFyIHMgPSBzb3VyY2VzLmdldChwcm9wKTtcblxuXHRcdFx0aWYgKHMgPT09IHVuZGVmaW5lZCkge1xuXHRcdFx0XHRzID0gc291cmNlKGRlc2NyaXB0b3IudmFsdWUsIHN0YWNrKTtcblx0XHRcdFx0c291cmNlcy5zZXQocHJvcCwgcyk7XG5cdFx0XHR9IGVsc2Uge1xuXHRcdFx0XHRzZXQocywgcHJveHkoZGVzY3JpcHRvci52YWx1ZSwgbWV0YWRhdGEpKTtcblx0XHRcdH1cblxuXHRcdFx0cmV0dXJuIHRydWU7XG5cdFx0fSxcblxuXHRcdGRlbGV0ZVByb3BlcnR5KHRhcmdldCwgcHJvcCkge1xuXHRcdFx0dmFyIHMgPSBzb3VyY2VzLmdldChwcm9wKTtcblxuXHRcdFx0aWYgKHMgPT09IHVuZGVmaW5lZCkge1xuXHRcdFx0XHRpZiAocHJvcCBpbiB0YXJnZXQpIHtcblx0XHRcdFx0XHRzb3VyY2VzLnNldChwcm9wLCBzb3VyY2UoVU5JTklUSUFMSVpFRCwgc3RhY2spKTtcblx0XHRcdFx0fVxuXHRcdFx0fSBlbHNlIHtcblx0XHRcdFx0Ly8gV2hlbiB3b3JraW5nIHdpdGggYXJyYXlzLCB3ZSBuZWVkIHRvIGFsc28gZW5zdXJlIHdlIHVwZGF0ZSB0aGUgbGVuZ3RoIHdoZW4gcmVtb3Zpbmdcblx0XHRcdFx0Ly8gYW4gaW5kZXhlZCBwcm9wZXJ0eVxuXHRcdFx0XHRpZiAoaXNfcHJveGllZF9hcnJheSAmJiB0eXBlb2YgcHJvcCA9PT0gJ3N0cmluZycpIHtcblx0XHRcdFx0XHR2YXIgbHMgPSAvKiogQHR5cGUge1NvdXJjZTxudW1iZXI+fSAqLyAoc291cmNlcy5nZXQoJ2xlbmd0aCcpKTtcblx0XHRcdFx0XHR2YXIgbiA9IE51bWJlcihwcm9wKTtcblxuXHRcdFx0XHRcdGlmIChOdW1iZXIuaXNJbnRlZ2VyKG4pICYmIG4gPCBscy52KSB7XG5cdFx0XHRcdFx0XHRzZXQobHMsIG4pO1xuXHRcdFx0XHRcdH1cblx0XHRcdFx0fVxuXHRcdFx0XHRzZXQocywgVU5JTklUSUFMSVpFRCk7XG5cdFx0XHRcdHVwZGF0ZV92ZXJzaW9uKHZlcnNpb24pO1xuXHRcdFx0fVxuXG5cdFx0XHRyZXR1cm4gdHJ1ZTtcblx0XHR9LFxuXG5cdFx0Z2V0KHRhcmdldCwgcHJvcCwgcmVjZWl2ZXIpIHtcblx0XHRcdGlmIChERVYgJiYgcHJvcCA9PT0gU1RBVEVfU1lNQk9MX01FVEFEQVRBKSB7XG5cdFx0XHRcdHJldHVybiBtZXRhZGF0YTtcblx0XHRcdH1cblxuXHRcdFx0aWYgKHByb3AgPT09IFNUQVRFX1NZTUJPTCkge1xuXHRcdFx0XHRyZXR1cm4gdmFsdWU7XG5cdFx0XHR9XG5cblx0XHRcdHZhciBzID0gc291cmNlcy5nZXQocHJvcCk7XG5cdFx0XHR2YXIgZXhpc3RzID0gcHJvcCBpbiB0YXJnZXQ7XG5cblx0XHRcdC8vIGNyZWF0ZSBhIHNvdXJjZSwgYnV0IG9ubHkgaWYgaXQncyBhbiBvd24gcHJvcGVydHkgYW5kIG5vdCBhIHByb3RvdHlwZSBwcm9wZXJ0eVxuXHRcdFx0aWYgKHMgPT09IHVuZGVmaW5lZCAmJiAoIWV4aXN0cyB8fCBnZXRfZGVzY3JpcHRvcih0YXJnZXQsIHByb3ApPy53cml0YWJsZSkpIHtcblx0XHRcdFx0cyA9IHNvdXJjZShwcm94eShleGlzdHMgPyB0YXJnZXRbcHJvcF0gOiBVTklOSVRJQUxJWkVELCBtZXRhZGF0YSksIHN0YWNrKTtcblx0XHRcdFx0c291cmNlcy5zZXQocHJvcCwgcyk7XG5cdFx0XHR9XG5cblx0XHRcdGlmIChzICE9PSB1bmRlZmluZWQpIHtcblx0XHRcdFx0dmFyIHYgPSBnZXQocyk7XG5cblx0XHRcdFx0Ly8gSW4gY2FzZSBvZiBzb21ldGhpbmcgbGlrZSBgZm9vID0gYmFyLm1hcCguLi4pYCwgZm9vIHdvdWxkIGhhdmUgb3duZXJzaGlwXG5cdFx0XHRcdC8vIG9mIHRoZSBhcnJheSBpdHNlbGYsIHdoaWxlIHRoZSBpbmRpdmlkdWFsIGl0ZW1zIHdvdWxkIGhhdmUgb3duZXJzaGlwXG5cdFx0XHRcdC8vIG9mIHRoZSBjb21wb25lbnQgdGhhdCBjcmVhdGVkIGJhci4gVGhhdCBtZWFucyBpZiB3ZSBsYXRlciBkbyBgZm9vWzBdLmJheiA9IDQyYCxcblx0XHRcdFx0Ly8gd2UgY291bGQgZ2V0IGEgZmFsc2UtcG9zaXRpdmUgb3duZXJzaGlwIHZpb2xhdGlvbiwgc2luY2UgdGhlIHR3byBwcm94aWVzXG5cdFx0XHRcdC8vIGFyZSBub3QgY29ubmVjdGVkIHRvIGVhY2ggb3RoZXIgdmlhIHRoZSBwYXJlbnQgbWV0YWRhdGEgcmVsYXRpb25zaGlwLlxuXHRcdFx0XHQvLyBGb3IgdGhpcyByZWFzb24sIHdlIG5lZWQgdG8gd2lkZW4gdGhlIG93bmVyc2hpcCBvZiB0aGUgY2hpbGRyZW5cblx0XHRcdFx0Ly8gdXBvbiBhY2Nlc3Mgd2hlbiB3ZSBkZXRlY3QgdGhleSBhcmUgbm90IGNvbm5lY3RlZC5cblx0XHRcdFx0aWYgKERFVikge1xuXHRcdFx0XHRcdC8qKiBAdHlwZSB7UHJveHlNZXRhZGF0YSB8IHVuZGVmaW5lZH0gKi9cblx0XHRcdFx0XHR2YXIgcHJvcF9tZXRhZGF0YSA9IHY/LltTVEFURV9TWU1CT0xfTUVUQURBVEFdO1xuXHRcdFx0XHRcdGlmIChwcm9wX21ldGFkYXRhICYmIHByb3BfbWV0YWRhdGE/LnBhcmVudCAhPT0gbWV0YWRhdGEpIHtcblx0XHRcdFx0XHRcdHdpZGVuX293bmVyc2hpcChtZXRhZGF0YSwgcHJvcF9tZXRhZGF0YSk7XG5cdFx0XHRcdFx0fVxuXHRcdFx0XHR9XG5cblx0XHRcdFx0cmV0dXJuIHYgPT09IFVOSU5JVElBTElaRUQgPyB1bmRlZmluZWQgOiB2O1xuXHRcdFx0fVxuXG5cdFx0XHRyZXR1cm4gUmVmbGVjdC5nZXQodGFyZ2V0LCBwcm9wLCByZWNlaXZlcik7XG5cdFx0fSxcblxuXHRcdGdldE93blByb3BlcnR5RGVzY3JpcHRvcih0YXJnZXQsIHByb3ApIHtcblx0XHRcdHZhciBkZXNjcmlwdG9yID0gUmVmbGVjdC5nZXRPd25Qcm9wZXJ0eURlc2NyaXB0b3IodGFyZ2V0LCBwcm9wKTtcblxuXHRcdFx0aWYgKGRlc2NyaXB0b3IgJiYgJ3ZhbHVlJyBpbiBkZXNjcmlwdG9yKSB7XG5cdFx0XHRcdHZhciBzID0gc291cmNlcy5nZXQocHJvcCk7XG5cdFx0XHRcdGlmIChzKSBkZXNjcmlwdG9yLnZhbHVlID0gZ2V0KHMpO1xuXHRcdFx0fSBlbHNlIGlmIChkZXNjcmlwdG9yID09PSB1bmRlZmluZWQpIHtcblx0XHRcdFx0dmFyIHNvdXJjZSA9IHNvdXJjZXMuZ2V0KHByb3ApO1xuXHRcdFx0XHR2YXIgdmFsdWUgPSBzb3VyY2U/LnY7XG5cblx0XHRcdFx0aWYgKHNvdXJjZSAhPT0gdW5kZWZpbmVkICYmIHZhbHVlICE9PSBVTklOSVRJQUxJWkVEKSB7XG5cdFx0XHRcdFx0cmV0dXJuIHtcblx0XHRcdFx0XHRcdGVudW1lcmFibGU6IHRydWUsXG5cdFx0XHRcdFx0XHRjb25maWd1cmFibGU6IHRydWUsXG5cdFx0XHRcdFx0XHR2YWx1ZSxcblx0XHRcdFx0XHRcdHdyaXRhYmxlOiB0cnVlXG5cdFx0XHRcdFx0fTtcblx0XHRcdFx0fVxuXHRcdFx0fVxuXG5cdFx0XHRyZXR1cm4gZGVzY3JpcHRvcjtcblx0XHR9LFxuXG5cdFx0aGFzKHRhcmdldCwgcHJvcCkge1xuXHRcdFx0aWYgKERFViAmJiBwcm9wID09PSBTVEFURV9TWU1CT0xfTUVUQURBVEEpIHtcblx0XHRcdFx0cmV0dXJuIHRydWU7XG5cdFx0XHR9XG5cblx0XHRcdGlmIChwcm9wID09PSBTVEFURV9TWU1CT0wpIHtcblx0XHRcdFx0cmV0dXJuIHRydWU7XG5cdFx0XHR9XG5cblx0XHRcdHZhciBzID0gc291cmNlcy5nZXQocHJvcCk7XG5cdFx0XHR2YXIgaGFzID0gKHMgIT09IHVuZGVmaW5lZCAmJiBzLnYgIT09IFVOSU5JVElBTElaRUQpIHx8IFJlZmxlY3QuaGFzKHRhcmdldCwgcHJvcCk7XG5cblx0XHRcdGlmIChcblx0XHRcdFx0cyAhPT0gdW5kZWZpbmVkIHx8XG5cdFx0XHRcdChhY3RpdmVfZWZmZWN0ICE9PSBudWxsICYmICghaGFzIHx8IGdldF9kZXNjcmlwdG9yKHRhcmdldCwgcHJvcCk/LndyaXRhYmxlKSlcblx0XHRcdCkge1xuXHRcdFx0XHRpZiAocyA9PT0gdW5kZWZpbmVkKSB7XG5cdFx0XHRcdFx0cyA9IHNvdXJjZShoYXMgPyBwcm94eSh0YXJnZXRbcHJvcF0sIG1ldGFkYXRhKSA6IFVOSU5JVElBTElaRUQsIHN0YWNrKTtcblx0XHRcdFx0XHRzb3VyY2VzLnNldChwcm9wLCBzKTtcblx0XHRcdFx0fVxuXG5cdFx0XHRcdHZhciB2YWx1ZSA9IGdldChzKTtcblx0XHRcdFx0aWYgKHZhbHVlID09PSBVTklOSVRJQUxJWkVEKSB7XG5cdFx0XHRcdFx0cmV0dXJuIGZhbHNlO1xuXHRcdFx0XHR9XG5cdFx0XHR9XG5cblx0XHRcdHJldHVybiBoYXM7XG5cdFx0fSxcblxuXHRcdHNldCh0YXJnZXQsIHByb3AsIHZhbHVlLCByZWNlaXZlcikge1xuXHRcdFx0dmFyIHMgPSBzb3VyY2VzLmdldChwcm9wKTtcblx0XHRcdHZhciBoYXMgPSBwcm9wIGluIHRhcmdldDtcblxuXHRcdFx0Ly8gdmFyaWFibGUubGVuZ3RoID0gdmFsdWUgLT4gY2xlYXIgYWxsIHNpZ25hbHMgd2l0aCBpbmRleCA+PSB2YWx1ZVxuXHRcdFx0aWYgKGlzX3Byb3hpZWRfYXJyYXkgJiYgcHJvcCA9PT0gJ2xlbmd0aCcpIHtcblx0XHRcdFx0Zm9yICh2YXIgaSA9IHZhbHVlOyBpIDwgLyoqIEB0eXBlIHtTb3VyY2U8bnVtYmVyPn0gKi8gKHMpLnY7IGkgKz0gMSkge1xuXHRcdFx0XHRcdHZhciBvdGhlcl9zID0gc291cmNlcy5nZXQoaSArICcnKTtcblx0XHRcdFx0XHRpZiAob3RoZXJfcyAhPT0gdW5kZWZpbmVkKSB7XG5cdFx0XHRcdFx0XHRzZXQob3RoZXJfcywgVU5JTklUSUFMSVpFRCk7XG5cdFx0XHRcdFx0fSBlbHNlIGlmIChpIGluIHRhcmdldCkge1xuXHRcdFx0XHRcdFx0Ly8gSWYgdGhlIGl0ZW0gZXhpc3RzIGluIHRoZSBvcmlnaW5hbCwgd2UgbmVlZCB0byBjcmVhdGUgYSB1bmluaXRpYWxpemVkIHNvdXJjZSxcblx0XHRcdFx0XHRcdC8vIGVsc2UgYSBsYXRlciByZWFkIG9mIHRoZSBwcm9wZXJ0eSB3b3VsZCByZXN1bHQgaW4gYSBzb3VyY2UgYmVpbmcgY3JlYXRlZCB3aXRoXG5cdFx0XHRcdFx0XHQvLyB0aGUgdmFsdWUgb2YgdGhlIG9yaWdpbmFsIGl0ZW0gYXQgdGhhdCBpbmRleC5cblx0XHRcdFx0XHRcdG90aGVyX3MgPSBzb3VyY2UoVU5JTklUSUFMSVpFRCwgc3RhY2spO1xuXHRcdFx0XHRcdFx0c291cmNlcy5zZXQoaSArICcnLCBvdGhlcl9zKTtcblx0XHRcdFx0XHR9XG5cdFx0XHRcdH1cblx0XHRcdH1cblxuXHRcdFx0Ly8gSWYgd2UgaGF2ZW4ndCB5ZXQgY3JlYXRlZCBhIHNvdXJjZSBmb3IgdGhpcyBwcm9wZXJ0eSwgd2UgbmVlZCB0byBlbnN1cmVcblx0XHRcdC8vIHdlIGRvIHNvIG90aGVyd2lzZSBpZiB3ZSByZWFkIGl0IGxhdGVyLCB0aGVuIHRoZSB3cml0ZSB3b24ndCBiZSB0cmFja2VkIGFuZFxuXHRcdFx0Ly8gdGhlIGhldXJpc3RpY3Mgb2YgZWZmZWN0cyB3aWxsIGJlIGRpZmZlcmVudCB2cyBpZiB3ZSBoYWQgcmVhZCB0aGUgcHJveGllZFxuXHRcdFx0Ly8gb2JqZWN0IHByb3BlcnR5IGJlZm9yZSB3cml0aW5nIHRvIHRoYXQgcHJvcGVydHkuXG5cdFx0XHRpZiAocyA9PT0gdW5kZWZpbmVkKSB7XG5cdFx0XHRcdGlmICghaGFzIHx8IGdldF9kZXNjcmlwdG9yKHRhcmdldCwgcHJvcCk/LndyaXRhYmxlKSB7XG5cdFx0XHRcdFx0cyA9IHNvdXJjZSh1bmRlZmluZWQsIHN0YWNrKTtcblx0XHRcdFx0XHRzZXQocywgcHJveHkodmFsdWUsIG1ldGFkYXRhKSk7XG5cdFx0XHRcdFx0c291cmNlcy5zZXQocHJvcCwgcyk7XG5cdFx0XHRcdH1cblx0XHRcdH0gZWxzZSB7XG5cdFx0XHRcdGhhcyA9IHMudiAhPT0gVU5JTklUSUFMSVpFRDtcblx0XHRcdFx0c2V0KHMsIHByb3h5KHZhbHVlLCBtZXRhZGF0YSkpO1xuXHRcdFx0fVxuXG5cdFx0XHRpZiAoREVWKSB7XG5cdFx0XHRcdC8qKiBAdHlwZSB7UHJveHlNZXRhZGF0YSB8IHVuZGVmaW5lZH0gKi9cblx0XHRcdFx0dmFyIHByb3BfbWV0YWRhdGEgPSB2YWx1ZT8uW1NUQVRFX1NZTUJPTF9NRVRBREFUQV07XG5cdFx0XHRcdGlmIChwcm9wX21ldGFkYXRhICYmIHByb3BfbWV0YWRhdGE/LnBhcmVudCAhPT0gbWV0YWRhdGEpIHtcblx0XHRcdFx0XHR3aWRlbl9vd25lcnNoaXAobWV0YWRhdGEsIHByb3BfbWV0YWRhdGEpO1xuXHRcdFx0XHR9XG5cdFx0XHRcdGNoZWNrX293bmVyc2hpcChtZXRhZGF0YSk7XG5cdFx0XHR9XG5cblx0XHRcdHZhciBkZXNjcmlwdG9yID0gUmVmbGVjdC5nZXRPd25Qcm9wZXJ0eURlc2NyaXB0b3IodGFyZ2V0LCBwcm9wKTtcblxuXHRcdFx0Ly8gU2V0IHRoZSBuZXcgdmFsdWUgYmVmb3JlIHVwZGF0aW5nIGFueSBzaWduYWxzIHNvIHRoYXQgYW55IGxpc3RlbmVycyBnZXQgdGhlIG5ldyB2YWx1ZVxuXHRcdFx0aWYgKGRlc2NyaXB0b3I/LnNldCkge1xuXHRcdFx0XHRkZXNjcmlwdG9yLnNldC5jYWxsKHJlY2VpdmVyLCB2YWx1ZSk7XG5cdFx0XHR9XG5cblx0XHRcdGlmICghaGFzKSB7XG5cdFx0XHRcdC8vIElmIHdlIGhhdmUgbXV0YXRlZCBhbiBhcnJheSBkaXJlY3RseSwgd2UgbWlnaHQgbmVlZCB0b1xuXHRcdFx0XHQvLyBzaWduYWwgdGhhdCBsZW5ndGggaGFzIGFsc28gY2hhbmdlZC4gRG8gaXQgYmVmb3JlIHVwZGF0aW5nIG1ldGFkYXRhXG5cdFx0XHRcdC8vIHRvIGVuc3VyZSB0aGF0IGl0ZXJhdGluZyBvdmVyIHRoZSBhcnJheSBhcyBhIHJlc3VsdCBvZiBhIG1ldGFkYXRhIHVwZGF0ZVxuXHRcdFx0XHQvLyB3aWxsIG5vdCBjYXVzZSB0aGUgbGVuZ3RoIHRvIGJlIG91dCBvZiBzeW5jLlxuXHRcdFx0XHRpZiAoaXNfcHJveGllZF9hcnJheSAmJiB0eXBlb2YgcHJvcCA9PT0gJ3N0cmluZycpIHtcblx0XHRcdFx0XHR2YXIgbHMgPSAvKiogQHR5cGUge1NvdXJjZTxudW1iZXI+fSAqLyAoc291cmNlcy5nZXQoJ2xlbmd0aCcpKTtcblx0XHRcdFx0XHR2YXIgbiA9IE51bWJlcihwcm9wKTtcblxuXHRcdFx0XHRcdGlmIChOdW1iZXIuaXNJbnRlZ2VyKG4pICYmIG4gPj0gbHMudikge1xuXHRcdFx0XHRcdFx0c2V0KGxzLCBuICsgMSk7XG5cdFx0XHRcdFx0fVxuXHRcdFx0XHR9XG5cblx0XHRcdFx0dXBkYXRlX3ZlcnNpb24odmVyc2lvbik7XG5cdFx0XHR9XG5cblx0XHRcdHJldHVybiB0cnVlO1xuXHRcdH0sXG5cblx0XHRvd25LZXlzKHRhcmdldCkge1xuXHRcdFx0Z2V0KHZlcnNpb24pO1xuXG5cdFx0XHR2YXIgb3duX2tleXMgPSBSZWZsZWN0Lm93bktleXModGFyZ2V0KS5maWx0ZXIoKGtleSkgPT4ge1xuXHRcdFx0XHR2YXIgc291cmNlID0gc291cmNlcy5nZXQoa2V5KTtcblx0XHRcdFx0cmV0dXJuIHNvdXJjZSA9PT0gdW5kZWZpbmVkIHx8IHNvdXJjZS52ICE9PSBVTklOSVRJQUxJWkVEO1xuXHRcdFx0fSk7XG5cblx0XHRcdGZvciAodmFyIFtrZXksIHNvdXJjZV0gb2Ygc291cmNlcykge1xuXHRcdFx0XHRpZiAoc291cmNlLnYgIT09IFVOSU5JVElBTElaRUQgJiYgIShrZXkgaW4gdGFyZ2V0KSkge1xuXHRcdFx0XHRcdG93bl9rZXlzLnB1c2goa2V5KTtcblx0XHRcdFx0fVxuXHRcdFx0fVxuXG5cdFx0XHRyZXR1cm4gb3duX2tleXM7XG5cdFx0fSxcblxuXHRcdHNldFByb3RvdHlwZU9mKCkge1xuXHRcdFx0ZS5zdGF0ZV9wcm90b3R5cGVfZml4ZWQoKTtcblx0XHR9XG5cdH0pO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7U291cmNlPG51bWJlcj59IHNpZ25hbFxuICogQHBhcmFtIHsxIHwgLTF9IFtkXVxuICovXG5mdW5jdGlvbiB1cGRhdGVfdmVyc2lvbihzaWduYWwsIGQgPSAxKSB7XG5cdHNldChzaWduYWwsIHNpZ25hbC52ICsgZCk7XG59XG5cbi8qKlxuICogQHBhcmFtIHthbnl9IHZhbHVlXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBnZXRfcHJveGllZF92YWx1ZSh2YWx1ZSkge1xuXHRpZiAodmFsdWUgIT09IG51bGwgJiYgdHlwZW9mIHZhbHVlID09PSAnb2JqZWN0JyAmJiBTVEFURV9TWU1CT0wgaW4gdmFsdWUpIHtcblx0XHRyZXR1cm4gdmFsdWVbU1RBVEVfU1lNQk9MXTtcblx0fVxuXG5cdHJldHVybiB2YWx1ZTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge2FueX0gYVxuICogQHBhcmFtIHthbnl9IGJcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGlzKGEsIGIpIHtcblx0cmV0dXJuIE9iamVjdC5pcyhnZXRfcHJveGllZF92YWx1ZShhKSwgZ2V0X3Byb3hpZWRfdmFsdWUoYikpO1xufVxuIiwgImltcG9ydCAqIGFzIHcgZnJvbSAnLi4vd2FybmluZ3MuanMnO1xuaW1wb3J0IHsgZ2V0X3Byb3hpZWRfdmFsdWUgfSBmcm9tICcuLi9wcm94eS5qcyc7XG5cbmV4cG9ydCBmdW5jdGlvbiBpbml0X2FycmF5X3Byb3RvdHlwZV93YXJuaW5ncygpIHtcblx0Y29uc3QgYXJyYXlfcHJvdG90eXBlID0gQXJyYXkucHJvdG90eXBlO1xuXHQvLyBUaGUgUkVQTCBlbmRzIHVwIGhlcmUgb3ZlciBhbmQgb3ZlciwgYW5kIHRoaXMgcHJldmVudHMgaXQgZnJvbSBhZGRpbmcgbW9yZSBhbmQgbW9yZSBwYXRjaGVzXG5cdC8vIG9mIHRoZSBzYW1lIGtpbmQgdG8gdGhlIHByb3RvdHlwZSwgd2hpY2ggd291bGQgc2xvdyBkb3duIGV2ZXJ5dGhpbmcgb3ZlciB0aW1lLlxuXHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdGNvbnN0IGNsZWFudXAgPSBBcnJheS5fX3N2ZWx0ZV9jbGVhbnVwO1xuXHRpZiAoY2xlYW51cCkge1xuXHRcdGNsZWFudXAoKTtcblx0fVxuXG5cdGNvbnN0IHsgaW5kZXhPZiwgbGFzdEluZGV4T2YsIGluY2x1ZGVzIH0gPSBhcnJheV9wcm90b3R5cGU7XG5cblx0YXJyYXlfcHJvdG90eXBlLmluZGV4T2YgPSBmdW5jdGlvbiAoaXRlbSwgZnJvbV9pbmRleCkge1xuXHRcdGNvbnN0IGluZGV4ID0gaW5kZXhPZi5jYWxsKHRoaXMsIGl0ZW0sIGZyb21faW5kZXgpO1xuXG5cdFx0aWYgKGluZGV4ID09PSAtMSkge1xuXHRcdFx0Zm9yIChsZXQgaSA9IGZyb21faW5kZXggPz8gMDsgaSA8IHRoaXMubGVuZ3RoOyBpICs9IDEpIHtcblx0XHRcdFx0aWYgKGdldF9wcm94aWVkX3ZhbHVlKHRoaXNbaV0pID09PSBpdGVtKSB7XG5cdFx0XHRcdFx0dy5zdGF0ZV9wcm94eV9lcXVhbGl0eV9taXNtYXRjaCgnYXJyYXkuaW5kZXhPZiguLi4pJyk7XG5cdFx0XHRcdFx0YnJlYWs7XG5cdFx0XHRcdH1cblx0XHRcdH1cblx0XHR9XG5cblx0XHRyZXR1cm4gaW5kZXg7XG5cdH07XG5cblx0YXJyYXlfcHJvdG90eXBlLmxhc3RJbmRleE9mID0gZnVuY3Rpb24gKGl0ZW0sIGZyb21faW5kZXgpIHtcblx0XHQvLyB3ZSBuZWVkIHRvIHNwZWNpZnkgdGhpcy5sZW5ndGggLSAxIGJlY2F1c2UgaXQncyBwcm9iYWJseSB1c2luZyBzb21ldGhpbmcgbGlrZVxuXHRcdC8vIGBhcmd1bWVudHNgIGluc2lkZSBzbyBwYXNzaW5nIHVuZGVmaW5lZCBpcyBkaWZmZXJlbnQgZnJvbSBub3QgcGFzc2luZyBhbnl0aGluZ1xuXHRcdGNvbnN0IGluZGV4ID0gbGFzdEluZGV4T2YuY2FsbCh0aGlzLCBpdGVtLCBmcm9tX2luZGV4ID8/IHRoaXMubGVuZ3RoIC0gMSk7XG5cblx0XHRpZiAoaW5kZXggPT09IC0xKSB7XG5cdFx0XHRmb3IgKGxldCBpID0gMDsgaSA8PSAoZnJvbV9pbmRleCA/PyB0aGlzLmxlbmd0aCAtIDEpOyBpICs9IDEpIHtcblx0XHRcdFx0aWYgKGdldF9wcm94aWVkX3ZhbHVlKHRoaXNbaV0pID09PSBpdGVtKSB7XG5cdFx0XHRcdFx0dy5zdGF0ZV9wcm94eV9lcXVhbGl0eV9taXNtYXRjaCgnYXJyYXkubGFzdEluZGV4T2YoLi4uKScpO1xuXHRcdFx0XHRcdGJyZWFrO1xuXHRcdFx0XHR9XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0cmV0dXJuIGluZGV4O1xuXHR9O1xuXG5cdGFycmF5X3Byb3RvdHlwZS5pbmNsdWRlcyA9IGZ1bmN0aW9uIChpdGVtLCBmcm9tX2luZGV4KSB7XG5cdFx0Y29uc3QgaGFzID0gaW5jbHVkZXMuY2FsbCh0aGlzLCBpdGVtLCBmcm9tX2luZGV4KTtcblxuXHRcdGlmICghaGFzKSB7XG5cdFx0XHRmb3IgKGxldCBpID0gMDsgaSA8IHRoaXMubGVuZ3RoOyBpICs9IDEpIHtcblx0XHRcdFx0aWYgKGdldF9wcm94aWVkX3ZhbHVlKHRoaXNbaV0pID09PSBpdGVtKSB7XG5cdFx0XHRcdFx0dy5zdGF0ZV9wcm94eV9lcXVhbGl0eV9taXNtYXRjaCgnYXJyYXkuaW5jbHVkZXMoLi4uKScpO1xuXHRcdFx0XHRcdGJyZWFrO1xuXHRcdFx0XHR9XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0cmV0dXJuIGhhcztcblx0fTtcblxuXHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdEFycmF5Ll9fc3ZlbHRlX2NsZWFudXAgPSAoKSA9PiB7XG5cdFx0YXJyYXlfcHJvdG90eXBlLmluZGV4T2YgPSBpbmRleE9mO1xuXHRcdGFycmF5X3Byb3RvdHlwZS5sYXN0SW5kZXhPZiA9IGxhc3RJbmRleE9mO1xuXHRcdGFycmF5X3Byb3RvdHlwZS5pbmNsdWRlcyA9IGluY2x1ZGVzO1xuXHR9O1xufVxuXG4vKipcbiAqIEBwYXJhbSB7YW55fSBhXG4gKiBAcGFyYW0ge2FueX0gYlxuICogQHBhcmFtIHtib29sZWFufSBlcXVhbFxuICogQHJldHVybnMge2Jvb2xlYW59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzdHJpY3RfZXF1YWxzKGEsIGIsIGVxdWFsID0gdHJ1ZSkge1xuXHQvLyB0cnktY2F0Y2ggbmVlZGVkIGJlY2F1c2UgdGhpcyB0cmllcyB0byByZWFkIHByb3BlcnRpZXMgb2YgYGFgIGFuZCBgYmAsXG5cdC8vIHdoaWNoIGNvdWxkIGJlIGRpc2FsbG93ZWQgZm9yIGV4YW1wbGUgaW4gYSBzZWN1cmUgY29udGV4dFxuXHR0cnkge1xuXHRcdGlmICgoYSA9PT0gYikgIT09IChnZXRfcHJveGllZF92YWx1ZShhKSA9PT0gZ2V0X3Byb3hpZWRfdmFsdWUoYikpKSB7XG5cdFx0XHR3LnN0YXRlX3Byb3h5X2VxdWFsaXR5X21pc21hdGNoKGVxdWFsID8gJz09PScgOiAnIT09Jyk7XG5cdFx0fVxuXHR9IGNhdGNoIHt9XG5cblx0cmV0dXJuIChhID09PSBiKSA9PT0gZXF1YWw7XG59XG5cbi8qKlxuICogQHBhcmFtIHthbnl9IGFcbiAqIEBwYXJhbSB7YW55fSBiXG4gKiBAcGFyYW0ge2Jvb2xlYW59IGVxdWFsXG4gKiBAcmV0dXJucyB7Ym9vbGVhbn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGVxdWFscyhhLCBiLCBlcXVhbCA9IHRydWUpIHtcblx0aWYgKChhID09IGIpICE9PSAoZ2V0X3Byb3hpZWRfdmFsdWUoYSkgPT0gZ2V0X3Byb3hpZWRfdmFsdWUoYikpKSB7XG5cdFx0dy5zdGF0ZV9wcm94eV9lcXVhbGl0eV9taXNtYXRjaChlcXVhbCA/ICc9PScgOiAnIT0nKTtcblx0fVxuXG5cdHJldHVybiAoYSA9PSBiKSA9PT0gZXF1YWw7XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBUZW1wbGF0ZU5vZGUgfSBmcm9tICcjY2xpZW50JyAqL1xuaW1wb3J0IHsgaHlkcmF0ZV9ub2RlLCBoeWRyYXRpbmcsIHNldF9oeWRyYXRlX25vZGUgfSBmcm9tICcuL2h5ZHJhdGlvbi5qcyc7XG5pbXBvcnQgeyBERVYgfSBmcm9tICdlc20tZW52JztcbmltcG9ydCB7IGluaXRfYXJyYXlfcHJvdG90eXBlX3dhcm5pbmdzIH0gZnJvbSAnLi4vZGV2L2VxdWFsaXR5LmpzJztcbmltcG9ydCB7IGdldF9kZXNjcmlwdG9yIH0gZnJvbSAnLi4vLi4vc2hhcmVkL3V0aWxzLmpzJztcblxuLy8gZXhwb3J0IHRoZXNlIGZvciByZWZlcmVuY2UgaW4gdGhlIGNvbXBpbGVkIGNvZGUsIG1ha2luZyBnbG9iYWwgbmFtZSBkZWR1cGxpY2F0aW9uIHVubmVjZXNzYXJ5XG4vKiogQHR5cGUge1dpbmRvd30gKi9cbmV4cG9ydCB2YXIgJHdpbmRvdztcblxuLyoqIEB0eXBlIHtEb2N1bWVudH0gKi9cbmV4cG9ydCB2YXIgJGRvY3VtZW50O1xuXG4vKiogQHR5cGUge2Jvb2xlYW59ICovXG5leHBvcnQgdmFyIGlzX2ZpcmVmb3g7XG5cbi8qKiBAdHlwZSB7KCkgPT4gTm9kZSB8IG51bGx9ICovXG52YXIgZmlyc3RfY2hpbGRfZ2V0dGVyO1xuLyoqIEB0eXBlIHsoKSA9PiBOb2RlIHwgbnVsbH0gKi9cbnZhciBuZXh0X3NpYmxpbmdfZ2V0dGVyO1xuXG4vKipcbiAqIEluaXRpYWxpemUgdGhlc2UgbGF6aWx5IHRvIGF2b2lkIGlzc3VlcyB3aGVuIHVzaW5nIHRoZSBydW50aW1lIGluIGEgc2VydmVyIGNvbnRleHRcbiAqIHdoZXJlIHRoZXNlIGdsb2JhbHMgYXJlIG5vdCBhdmFpbGFibGUgd2hpbGUgYXZvaWRpbmcgYSBzZXBhcmF0ZSBzZXJ2ZXIgZW50cnkgcG9pbnRcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGluaXRfb3BlcmF0aW9ucygpIHtcblx0aWYgKCR3aW5kb3cgIT09IHVuZGVmaW5lZCkge1xuXHRcdHJldHVybjtcblx0fVxuXG5cdCR3aW5kb3cgPSB3aW5kb3c7XG5cdCRkb2N1bWVudCA9IGRvY3VtZW50O1xuXHRpc19maXJlZm94ID0gL0ZpcmVmb3gvLnRlc3QobmF2aWdhdG9yLnVzZXJBZ2VudCk7XG5cblx0dmFyIGVsZW1lbnRfcHJvdG90eXBlID0gRWxlbWVudC5wcm90b3R5cGU7XG5cdHZhciBub2RlX3Byb3RvdHlwZSA9IE5vZGUucHJvdG90eXBlO1xuXG5cdC8vIEB0cy1pZ25vcmVcblx0Zmlyc3RfY2hpbGRfZ2V0dGVyID0gZ2V0X2Rlc2NyaXB0b3Iobm9kZV9wcm90b3R5cGUsICdmaXJzdENoaWxkJykuZ2V0O1xuXHQvLyBAdHMtaWdub3JlXG5cdG5leHRfc2libGluZ19nZXR0ZXIgPSBnZXRfZGVzY3JpcHRvcihub2RlX3Byb3RvdHlwZSwgJ25leHRTaWJsaW5nJykuZ2V0O1xuXG5cdC8vIHRoZSBmb2xsb3dpbmcgYXNzaWdubWVudHMgaW1wcm92ZSBwZXJmIG9mIGxvb2t1cHMgb24gRE9NIG5vZGVzXG5cdC8vIEB0cy1leHBlY3QtZXJyb3Jcblx0ZWxlbWVudF9wcm90b3R5cGUuX19jbGljayA9IHVuZGVmaW5lZDtcblx0Ly8gQHRzLWV4cGVjdC1lcnJvclxuXHRlbGVtZW50X3Byb3RvdHlwZS5fX2NsYXNzTmFtZSA9ICcnO1xuXHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdGVsZW1lbnRfcHJvdG90eXBlLl9fYXR0cmlidXRlcyA9IG51bGw7XG5cdC8vIEB0cy1leHBlY3QtZXJyb3Jcblx0ZWxlbWVudF9wcm90b3R5cGUuX19zdHlsZXMgPSBudWxsO1xuXHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdGVsZW1lbnRfcHJvdG90eXBlLl9fZSA9IHVuZGVmaW5lZDtcblxuXHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdFRleHQucHJvdG90eXBlLl9fdCA9IHVuZGVmaW5lZDtcblxuXHRpZiAoREVWKSB7XG5cdFx0Ly8gQHRzLWV4cGVjdC1lcnJvclxuXHRcdGVsZW1lbnRfcHJvdG90eXBlLl9fc3ZlbHRlX21ldGEgPSBudWxsO1xuXG5cdFx0aW5pdF9hcnJheV9wcm90b3R5cGVfd2FybmluZ3MoKTtcblx0fVxufVxuXG4vKipcbiAqIEBwYXJhbSB7c3RyaW5nfSB2YWx1ZVxuICogQHJldHVybnMge1RleHR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjcmVhdGVfdGV4dCh2YWx1ZSA9ICcnKSB7XG5cdHJldHVybiBkb2N1bWVudC5jcmVhdGVUZXh0Tm9kZSh2YWx1ZSk7XG59XG5cbi8qKlxuICogQHRlbXBsYXRlIHtOb2RlfSBOXG4gKiBAcGFyYW0ge059IG5vZGVcbiAqIEByZXR1cm5zIHtOb2RlIHwgbnVsbH1cbiAqL1xuLypAX19OT19TSURFX0VGRkVDVFNfXyovXG5leHBvcnQgZnVuY3Rpb24gZ2V0X2ZpcnN0X2NoaWxkKG5vZGUpIHtcblx0cmV0dXJuIGZpcnN0X2NoaWxkX2dldHRlci5jYWxsKG5vZGUpO1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSB7Tm9kZX0gTlxuICogQHBhcmFtIHtOfSBub2RlXG4gKiBAcmV0dXJucyB7Tm9kZSB8IG51bGx9XG4gKi9cbi8qQF9fTk9fU0lERV9FRkZFQ1RTX18qL1xuZXhwb3J0IGZ1bmN0aW9uIGdldF9uZXh0X3NpYmxpbmcobm9kZSkge1xuXHRyZXR1cm4gbmV4dF9zaWJsaW5nX2dldHRlci5jYWxsKG5vZGUpO1xufVxuXG4vKipcbiAqIERvbid0IG1hcmsgdGhpcyBhcyBzaWRlLWVmZmVjdC1mcmVlLCBoeWRyYXRpb24gbmVlZHMgdG8gd2FsayBhbGwgbm9kZXNcbiAqIEB0ZW1wbGF0ZSB7Tm9kZX0gTlxuICogQHBhcmFtIHtOfSBub2RlXG4gKiBAcGFyYW0ge2Jvb2xlYW59IGlzX3RleHRcbiAqIEByZXR1cm5zIHtOb2RlIHwgbnVsbH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGNoaWxkKG5vZGUsIGlzX3RleHQpIHtcblx0aWYgKCFoeWRyYXRpbmcpIHtcblx0XHRyZXR1cm4gZ2V0X2ZpcnN0X2NoaWxkKG5vZGUpO1xuXHR9XG5cblx0dmFyIGNoaWxkID0gLyoqIEB0eXBlIHtUZW1wbGF0ZU5vZGV9ICovIChnZXRfZmlyc3RfY2hpbGQoaHlkcmF0ZV9ub2RlKSk7XG5cblx0Ly8gQ2hpbGQgY2FuIGJlIG51bGwgaWYgd2UgaGF2ZSBhbiBlbGVtZW50IHdpdGggYSBzaW5nbGUgY2hpbGQsIGxpa2UgYDxwPnt0ZXh0fTwvcD5gLCB3aGVyZSBgdGV4dGAgaXMgZW1wdHlcblx0aWYgKGNoaWxkID09PSBudWxsKSB7XG5cdFx0Y2hpbGQgPSBoeWRyYXRlX25vZGUuYXBwZW5kQ2hpbGQoY3JlYXRlX3RleHQoKSk7XG5cdH0gZWxzZSBpZiAoaXNfdGV4dCAmJiBjaGlsZC5ub2RlVHlwZSAhPT0gMykge1xuXHRcdHZhciB0ZXh0ID0gY3JlYXRlX3RleHQoKTtcblx0XHRjaGlsZD8uYmVmb3JlKHRleHQpO1xuXHRcdHNldF9oeWRyYXRlX25vZGUodGV4dCk7XG5cdFx0cmV0dXJuIHRleHQ7XG5cdH1cblxuXHRzZXRfaHlkcmF0ZV9ub2RlKGNoaWxkKTtcblx0cmV0dXJuIGNoaWxkO1xufVxuXG4vKipcbiAqIERvbid0IG1hcmsgdGhpcyBhcyBzaWRlLWVmZmVjdC1mcmVlLCBoeWRyYXRpb24gbmVlZHMgdG8gd2FsayBhbGwgbm9kZXNcbiAqIEBwYXJhbSB7RG9jdW1lbnRGcmFnbWVudCB8IFRlbXBsYXRlTm9kZVtdfSBmcmFnbWVudFxuICogQHBhcmFtIHtib29sZWFufSBpc190ZXh0XG4gKiBAcmV0dXJucyB7Tm9kZSB8IG51bGx9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBmaXJzdF9jaGlsZChmcmFnbWVudCwgaXNfdGV4dCkge1xuXHRpZiAoIWh5ZHJhdGluZykge1xuXHRcdC8vIHdoZW4gbm90IGh5ZHJhdGluZywgYGZyYWdtZW50YCBpcyBhIGBEb2N1bWVudEZyYWdtZW50YCAodGhlIHJlc3VsdCBvZiBjYWxsaW5nIGBvcGVuX2ZyYWdgKVxuXHRcdHZhciBmaXJzdCA9IC8qKiBAdHlwZSB7RG9jdW1lbnRGcmFnbWVudH0gKi8gKGdldF9maXJzdF9jaGlsZCgvKiogQHR5cGUge05vZGV9ICovIChmcmFnbWVudCkpKTtcblxuXHRcdC8vIFRPRE8gcHJldmVudCB1c2VyIGNvbW1lbnRzIHdpdGggdGhlIGVtcHR5IHN0cmluZyB3aGVuIHByZXNlcnZlQ29tbWVudHMgaXMgdHJ1ZVxuXHRcdGlmIChmaXJzdCBpbnN0YW5jZW9mIENvbW1lbnQgJiYgZmlyc3QuZGF0YSA9PT0gJycpIHJldHVybiBnZXRfbmV4dF9zaWJsaW5nKGZpcnN0KTtcblxuXHRcdHJldHVybiBmaXJzdDtcblx0fVxuXG5cdC8vIGlmIGFuIHtleHByZXNzaW9ufSBpcyBlbXB0eSBkdXJpbmcgU1NSLCB0aGVyZSBtaWdodCBiZSBub1xuXHQvLyB0ZXh0IG5vZGUgdG8gaHlkcmF0ZSBcdTIwMTQgd2UgbXVzdCB0aGVyZWZvcmUgY3JlYXRlIG9uZVxuXHRpZiAoaXNfdGV4dCAmJiBoeWRyYXRlX25vZGU/Lm5vZGVUeXBlICE9PSAzKSB7XG5cdFx0dmFyIHRleHQgPSBjcmVhdGVfdGV4dCgpO1xuXG5cdFx0aHlkcmF0ZV9ub2RlPy5iZWZvcmUodGV4dCk7XG5cdFx0c2V0X2h5ZHJhdGVfbm9kZSh0ZXh0KTtcblx0XHRyZXR1cm4gdGV4dDtcblx0fVxuXG5cdHJldHVybiBoeWRyYXRlX25vZGU7XG59XG5cbi8qKlxuICogRG9uJ3QgbWFyayB0aGlzIGFzIHNpZGUtZWZmZWN0LWZyZWUsIGh5ZHJhdGlvbiBuZWVkcyB0byB3YWxrIGFsbCBub2Rlc1xuICogQHBhcmFtIHtUZW1wbGF0ZU5vZGV9IG5vZGVcbiAqIEBwYXJhbSB7bnVtYmVyfSBjb3VudFxuICogQHBhcmFtIHtib29sZWFufSBpc190ZXh0XG4gKiBAcmV0dXJucyB7Tm9kZSB8IG51bGx9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzaWJsaW5nKG5vZGUsIGNvdW50ID0gMSwgaXNfdGV4dCA9IGZhbHNlKSB7XG5cdGxldCBuZXh0X3NpYmxpbmcgPSBoeWRyYXRpbmcgPyBoeWRyYXRlX25vZGUgOiBub2RlO1xuXHR2YXIgbGFzdF9zaWJsaW5nO1xuXG5cdHdoaWxlIChjb3VudC0tKSB7XG5cdFx0bGFzdF9zaWJsaW5nID0gbmV4dF9zaWJsaW5nO1xuXHRcdG5leHRfc2libGluZyA9IC8qKiBAdHlwZSB7VGVtcGxhdGVOb2RlfSAqLyAoZ2V0X25leHRfc2libGluZyhuZXh0X3NpYmxpbmcpKTtcblx0fVxuXG5cdGlmICghaHlkcmF0aW5nKSB7XG5cdFx0cmV0dXJuIG5leHRfc2libGluZztcblx0fVxuXG5cdHZhciB0eXBlID0gbmV4dF9zaWJsaW5nPy5ub2RlVHlwZTtcblxuXHQvLyBpZiBhIHNpYmxpbmcge2V4cHJlc3Npb259IGlzIGVtcHR5IGR1cmluZyBTU1IsIHRoZXJlIG1pZ2h0IGJlIG5vXG5cdC8vIHRleHQgbm9kZSB0byBoeWRyYXRlIFx1MjAxNCB3ZSBtdXN0IHRoZXJlZm9yZSBjcmVhdGUgb25lXG5cdGlmIChpc190ZXh0ICYmIHR5cGUgIT09IDMpIHtcblx0XHR2YXIgdGV4dCA9IGNyZWF0ZV90ZXh0KCk7XG5cdFx0Ly8gSWYgdGhlIG5leHQgc2libGluZyBpcyBgbnVsbGAgYW5kIHdlJ3JlIGhhbmRsaW5nIHRleHQgdGhlbiBpdCdzIGJlY2F1c2Vcblx0XHQvLyB0aGUgU1NSIGNvbnRlbnQgd2FzIGVtcHR5IGZvciB0aGUgdGV4dCwgc28gd2UgbmVlZCB0byBnZW5lcmF0ZSBhIG5ldyB0ZXh0XG5cdFx0Ly8gbm9kZSBhbmQgaW5zZXJ0IGl0IGFmdGVyIHRoZSBsYXN0IHNpYmxpbmdcblx0XHRpZiAobmV4dF9zaWJsaW5nID09PSBudWxsKSB7XG5cdFx0XHRsYXN0X3NpYmxpbmc/LmFmdGVyKHRleHQpO1xuXHRcdH0gZWxzZSB7XG5cdFx0XHRuZXh0X3NpYmxpbmcuYmVmb3JlKHRleHQpO1xuXHRcdH1cblx0XHRzZXRfaHlkcmF0ZV9ub2RlKHRleHQpO1xuXHRcdHJldHVybiB0ZXh0O1xuXHR9XG5cblx0c2V0X2h5ZHJhdGVfbm9kZShuZXh0X3NpYmxpbmcpO1xuXHRyZXR1cm4gLyoqIEB0eXBlIHtUZW1wbGF0ZU5vZGV9ICovIChuZXh0X3NpYmxpbmcpO1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSB7Tm9kZX0gTlxuICogQHBhcmFtIHtOfSBub2RlXG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGNsZWFyX3RleHRfY29udGVudChub2RlKSB7XG5cdG5vZGUudGV4dENvbnRlbnQgPSAnJztcbn1cbiIsICIvKiogQGltcG9ydCB7IERlcml2ZWQsIEVmZmVjdCB9IGZyb20gJyNjbGllbnQnICovXG5pbXBvcnQgeyBERVYgfSBmcm9tICdlc20tZW52JztcbmltcG9ydCB7IENMRUFOLCBERVJJVkVELCBESVJUWSwgRUZGRUNUX0hBU19ERVJJVkVELCBNQVlCRV9ESVJUWSwgVU5PV05FRCB9IGZyb20gJy4uL2NvbnN0YW50cy5qcyc7XG5pbXBvcnQge1xuXHRhY3RpdmVfcmVhY3Rpb24sXG5cdGFjdGl2ZV9lZmZlY3QsXG5cdHNldF9zaWduYWxfc3RhdHVzLFxuXHRza2lwX3JlYWN0aW9uLFxuXHR1cGRhdGVfcmVhY3Rpb24sXG5cdGluY3JlbWVudF93cml0ZV92ZXJzaW9uLFxuXHRzZXRfYWN0aXZlX2VmZmVjdFxufSBmcm9tICcuLi9ydW50aW1lLmpzJztcbmltcG9ydCB7IGVxdWFscywgc2FmZV9lcXVhbHMgfSBmcm9tICcuL2VxdWFsaXR5LmpzJztcbmltcG9ydCAqIGFzIGUgZnJvbSAnLi4vZXJyb3JzLmpzJztcbmltcG9ydCB7IGRlc3Ryb3lfZWZmZWN0IH0gZnJvbSAnLi9lZmZlY3RzLmpzJztcbmltcG9ydCB7IGluc3BlY3RfZWZmZWN0cywgc2V0X2luc3BlY3RfZWZmZWN0cyB9IGZyb20gJy4vc291cmNlcy5qcyc7XG5pbXBvcnQgeyBnZXRfc3RhY2sgfSBmcm9tICcuLi9kZXYvdHJhY2luZy5qcyc7XG5pbXBvcnQgeyB0cmFjaW5nX21vZGVfZmxhZyB9IGZyb20gJy4uLy4uL2ZsYWdzL2luZGV4LmpzJztcbmltcG9ydCB7IGNvbXBvbmVudF9jb250ZXh0IH0gZnJvbSAnLi4vY29udGV4dC5qcyc7XG5cbi8qKlxuICogQHRlbXBsYXRlIFZcbiAqIEBwYXJhbSB7KCkgPT4gVn0gZm5cbiAqIEByZXR1cm5zIHtEZXJpdmVkPFY+fVxuICovXG4vKiNfX05PX1NJREVfRUZGRUNUU19fKi9cbmV4cG9ydCBmdW5jdGlvbiBkZXJpdmVkKGZuKSB7XG5cdHZhciBmbGFncyA9IERFUklWRUQgfCBESVJUWTtcblx0dmFyIHBhcmVudF9kZXJpdmVkID1cblx0XHRhY3RpdmVfcmVhY3Rpb24gIT09IG51bGwgJiYgKGFjdGl2ZV9yZWFjdGlvbi5mICYgREVSSVZFRCkgIT09IDBcblx0XHRcdD8gLyoqIEB0eXBlIHtEZXJpdmVkfSAqLyAoYWN0aXZlX3JlYWN0aW9uKVxuXHRcdFx0OiBudWxsO1xuXG5cdGlmIChhY3RpdmVfZWZmZWN0ID09PSBudWxsIHx8IChwYXJlbnRfZGVyaXZlZCAhPT0gbnVsbCAmJiAocGFyZW50X2Rlcml2ZWQuZiAmIFVOT1dORUQpICE9PSAwKSkge1xuXHRcdGZsYWdzIHw9IFVOT1dORUQ7XG5cdH0gZWxzZSB7XG5cdFx0Ly8gU2luY2UgZGVyaXZlZHMgYXJlIGV2YWx1YXRlZCBsYXppbHksIGFueSBlZmZlY3RzIGNyZWF0ZWQgaW5zaWRlIHRoZW0gYXJlXG5cdFx0Ly8gY3JlYXRlZCB0b28gbGF0ZSB0byBlbnN1cmUgdGhhdCB0aGUgcGFyZW50IGVmZmVjdCBpcyBhZGRlZCB0byB0aGUgdHJlZVxuXHRcdGFjdGl2ZV9lZmZlY3QuZiB8PSBFRkZFQ1RfSEFTX0RFUklWRUQ7XG5cdH1cblxuXHQvKiogQHR5cGUge0Rlcml2ZWQ8Vj59ICovXG5cdGNvbnN0IHNpZ25hbCA9IHtcblx0XHRjdHg6IGNvbXBvbmVudF9jb250ZXh0LFxuXHRcdGRlcHM6IG51bGwsXG5cdFx0ZWZmZWN0czogbnVsbCxcblx0XHRlcXVhbHMsXG5cdFx0ZjogZmxhZ3MsXG5cdFx0Zm4sXG5cdFx0cmVhY3Rpb25zOiBudWxsLFxuXHRcdHJ2OiAwLFxuXHRcdHY6IC8qKiBAdHlwZSB7Vn0gKi8gKG51bGwpLFxuXHRcdHd2OiAwLFxuXHRcdHBhcmVudDogcGFyZW50X2Rlcml2ZWQgPz8gYWN0aXZlX2VmZmVjdFxuXHR9O1xuXG5cdGlmIChERVYgJiYgdHJhY2luZ19tb2RlX2ZsYWcpIHtcblx0XHRzaWduYWwuY3JlYXRlZCA9IGdldF9zdGFjaygnQ3JlYXRlZEF0Jyk7XG5cdH1cblxuXHRyZXR1cm4gc2lnbmFsO1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0geygpID0+IFZ9IGZuXG4gKiBAcmV0dXJucyB7RGVyaXZlZDxWPn1cbiAqL1xuLyojX19OT19TSURFX0VGRkVDVFNfXyovXG5leHBvcnQgZnVuY3Rpb24gZGVyaXZlZF9zYWZlX2VxdWFsKGZuKSB7XG5cdGNvbnN0IHNpZ25hbCA9IGRlcml2ZWQoZm4pO1xuXHRzaWduYWwuZXF1YWxzID0gc2FmZV9lcXVhbHM7XG5cdHJldHVybiBzaWduYWw7XG59XG5cbi8qKlxuICogQHBhcmFtIHtEZXJpdmVkfSBkZXJpdmVkXG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGRlc3Ryb3lfZGVyaXZlZF9lZmZlY3RzKGRlcml2ZWQpIHtcblx0dmFyIGVmZmVjdHMgPSBkZXJpdmVkLmVmZmVjdHM7XG5cblx0aWYgKGVmZmVjdHMgIT09IG51bGwpIHtcblx0XHRkZXJpdmVkLmVmZmVjdHMgPSBudWxsO1xuXG5cdFx0Zm9yICh2YXIgaSA9IDA7IGkgPCBlZmZlY3RzLmxlbmd0aDsgaSArPSAxKSB7XG5cdFx0XHRkZXN0cm95X2VmZmVjdCgvKiogQHR5cGUge0VmZmVjdH0gKi8gKGVmZmVjdHNbaV0pKTtcblx0XHR9XG5cdH1cbn1cblxuLyoqXG4gKiBUaGUgY3VycmVudGx5IHVwZGF0aW5nIGRlcml2ZWRzLCB1c2VkIHRvIGRldGVjdCBpbmZpbml0ZSByZWN1cnNpb25cbiAqIGluIGRldiBtb2RlIGFuZCBwcm92aWRlIGEgbmljZXIgZXJyb3IgdGhhbiAndG9vIG11Y2ggcmVjdXJzaW9uJ1xuICogQHR5cGUge0Rlcml2ZWRbXX1cbiAqL1xubGV0IHN0YWNrID0gW107XG5cbi8qKlxuICogQHBhcmFtIHtEZXJpdmVkfSBkZXJpdmVkXG4gKiBAcmV0dXJucyB7RWZmZWN0IHwgbnVsbH1cbiAqL1xuZnVuY3Rpb24gZ2V0X2Rlcml2ZWRfcGFyZW50X2VmZmVjdChkZXJpdmVkKSB7XG5cdHZhciBwYXJlbnQgPSBkZXJpdmVkLnBhcmVudDtcblx0d2hpbGUgKHBhcmVudCAhPT0gbnVsbCkge1xuXHRcdGlmICgocGFyZW50LmYgJiBERVJJVkVEKSA9PT0gMCkge1xuXHRcdFx0cmV0dXJuIC8qKiBAdHlwZSB7RWZmZWN0fSAqLyAocGFyZW50KTtcblx0XHR9XG5cdFx0cGFyZW50ID0gcGFyZW50LnBhcmVudDtcblx0fVxuXHRyZXR1cm4gbnVsbDtcbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUgVFxuICogQHBhcmFtIHtEZXJpdmVkfSBkZXJpdmVkXG4gKiBAcmV0dXJucyB7VH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGV4ZWN1dGVfZGVyaXZlZChkZXJpdmVkKSB7XG5cdHZhciB2YWx1ZTtcblx0dmFyIHByZXZfYWN0aXZlX2VmZmVjdCA9IGFjdGl2ZV9lZmZlY3Q7XG5cblx0c2V0X2FjdGl2ZV9lZmZlY3QoZ2V0X2Rlcml2ZWRfcGFyZW50X2VmZmVjdChkZXJpdmVkKSk7XG5cblx0aWYgKERFVikge1xuXHRcdGxldCBwcmV2X2luc3BlY3RfZWZmZWN0cyA9IGluc3BlY3RfZWZmZWN0cztcblx0XHRzZXRfaW5zcGVjdF9lZmZlY3RzKG5ldyBTZXQoKSk7XG5cdFx0dHJ5IHtcblx0XHRcdGlmIChzdGFjay5pbmNsdWRlcyhkZXJpdmVkKSkge1xuXHRcdFx0XHRlLmRlcml2ZWRfcmVmZXJlbmNlc19zZWxmKCk7XG5cdFx0XHR9XG5cblx0XHRcdHN0YWNrLnB1c2goZGVyaXZlZCk7XG5cblx0XHRcdGRlc3Ryb3lfZGVyaXZlZF9lZmZlY3RzKGRlcml2ZWQpO1xuXHRcdFx0dmFsdWUgPSB1cGRhdGVfcmVhY3Rpb24oZGVyaXZlZCk7XG5cdFx0fSBmaW5hbGx5IHtcblx0XHRcdHNldF9hY3RpdmVfZWZmZWN0KHByZXZfYWN0aXZlX2VmZmVjdCk7XG5cdFx0XHRzZXRfaW5zcGVjdF9lZmZlY3RzKHByZXZfaW5zcGVjdF9lZmZlY3RzKTtcblx0XHRcdHN0YWNrLnBvcCgpO1xuXHRcdH1cblx0fSBlbHNlIHtcblx0XHR0cnkge1xuXHRcdFx0ZGVzdHJveV9kZXJpdmVkX2VmZmVjdHMoZGVyaXZlZCk7XG5cdFx0XHR2YWx1ZSA9IHVwZGF0ZV9yZWFjdGlvbihkZXJpdmVkKTtcblx0XHR9IGZpbmFsbHkge1xuXHRcdFx0c2V0X2FjdGl2ZV9lZmZlY3QocHJldl9hY3RpdmVfZWZmZWN0KTtcblx0XHR9XG5cdH1cblxuXHRyZXR1cm4gdmFsdWU7XG59XG5cbi8qKlxuICogQHBhcmFtIHtEZXJpdmVkfSBkZXJpdmVkXG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHVwZGF0ZV9kZXJpdmVkKGRlcml2ZWQpIHtcblx0dmFyIHZhbHVlID0gZXhlY3V0ZV9kZXJpdmVkKGRlcml2ZWQpO1xuXHR2YXIgc3RhdHVzID1cblx0XHQoc2tpcF9yZWFjdGlvbiB8fCAoZGVyaXZlZC5mICYgVU5PV05FRCkgIT09IDApICYmIGRlcml2ZWQuZGVwcyAhPT0gbnVsbCA/IE1BWUJFX0RJUlRZIDogQ0xFQU47XG5cblx0c2V0X3NpZ25hbF9zdGF0dXMoZGVyaXZlZCwgc3RhdHVzKTtcblxuXHRpZiAoIWRlcml2ZWQuZXF1YWxzKHZhbHVlKSkge1xuXHRcdGRlcml2ZWQudiA9IHZhbHVlO1xuXHRcdGRlcml2ZWQud3YgPSBpbmNyZW1lbnRfd3JpdGVfdmVyc2lvbigpO1xuXHR9XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBDb21wb25lbnRDb250ZXh0LCBDb21wb25lbnRDb250ZXh0TGVnYWN5LCBEZXJpdmVkLCBFZmZlY3QsIFRlbXBsYXRlTm9kZSwgVHJhbnNpdGlvbk1hbmFnZXIgfSBmcm9tICcjY2xpZW50JyAqL1xuaW1wb3J0IHtcblx0Y2hlY2tfZGlydGluZXNzLFxuXHRhY3RpdmVfZWZmZWN0LFxuXHRhY3RpdmVfcmVhY3Rpb24sXG5cdHVwZGF0ZV9lZmZlY3QsXG5cdGdldCxcblx0aXNfZGVzdHJveWluZ19lZmZlY3QsXG5cdGlzX2ZsdXNoaW5nX2VmZmVjdCxcblx0cmVtb3ZlX3JlYWN0aW9ucyxcblx0c2NoZWR1bGVfZWZmZWN0LFxuXHRzZXRfYWN0aXZlX3JlYWN0aW9uLFxuXHRzZXRfaXNfZGVzdHJveWluZ19lZmZlY3QsXG5cdHNldF9pc19mbHVzaGluZ19lZmZlY3QsXG5cdHNldF9zaWduYWxfc3RhdHVzLFxuXHR1bnRyYWNrLFxuXHRza2lwX3JlYWN0aW9uLFxuXHR1bnRyYWNraW5nXG59IGZyb20gJy4uL3J1bnRpbWUuanMnO1xuaW1wb3J0IHtcblx0RElSVFksXG5cdEJSQU5DSF9FRkZFQ1QsXG5cdFJFTkRFUl9FRkZFQ1QsXG5cdEVGRkVDVCxcblx0REVTVFJPWUVELFxuXHRJTkVSVCxcblx0RUZGRUNUX1JBTixcblx0QkxPQ0tfRUZGRUNULFxuXHRST09UX0VGRkVDVCxcblx0RUZGRUNUX1RSQU5TUEFSRU5ULFxuXHRERVJJVkVELFxuXHRVTk9XTkVELFxuXHRDTEVBTixcblx0SU5TUEVDVF9FRkZFQ1QsXG5cdEhFQURfRUZGRUNULFxuXHRNQVlCRV9ESVJUWSxcblx0RUZGRUNUX0hBU19ERVJJVkVELFxuXHRCT1VOREFSWV9FRkZFQ1Rcbn0gZnJvbSAnLi4vY29uc3RhbnRzLmpzJztcbmltcG9ydCB7IHNldCB9IGZyb20gJy4vc291cmNlcy5qcyc7XG5pbXBvcnQgKiBhcyBlIGZyb20gJy4uL2Vycm9ycy5qcyc7XG5pbXBvcnQgeyBERVYgfSBmcm9tICdlc20tZW52JztcbmltcG9ydCB7IGRlZmluZV9wcm9wZXJ0eSB9IGZyb20gJy4uLy4uL3NoYXJlZC91dGlscy5qcyc7XG5pbXBvcnQgeyBnZXRfbmV4dF9zaWJsaW5nIH0gZnJvbSAnLi4vZG9tL29wZXJhdGlvbnMuanMnO1xuaW1wb3J0IHsgZGVyaXZlZCB9IGZyb20gJy4vZGVyaXZlZHMuanMnO1xuaW1wb3J0IHsgY29tcG9uZW50X2NvbnRleHQsIGRldl9jdXJyZW50X2NvbXBvbmVudF9mdW5jdGlvbiB9IGZyb20gJy4uL2NvbnRleHQuanMnO1xuXG4vKipcbiAqIEBwYXJhbSB7JyRlZmZlY3QnIHwgJyRlZmZlY3QucHJlJyB8ICckaW5zcGVjdCd9IHJ1bmVcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHZhbGlkYXRlX2VmZmVjdChydW5lKSB7XG5cdGlmIChhY3RpdmVfZWZmZWN0ID09PSBudWxsICYmIGFjdGl2ZV9yZWFjdGlvbiA9PT0gbnVsbCkge1xuXHRcdGUuZWZmZWN0X29ycGhhbihydW5lKTtcblx0fVxuXG5cdGlmIChhY3RpdmVfcmVhY3Rpb24gIT09IG51bGwgJiYgKGFjdGl2ZV9yZWFjdGlvbi5mICYgVU5PV05FRCkgIT09IDAgJiYgYWN0aXZlX2VmZmVjdCA9PT0gbnVsbCkge1xuXHRcdGUuZWZmZWN0X2luX3Vub3duZWRfZGVyaXZlZCgpO1xuXHR9XG5cblx0aWYgKGlzX2Rlc3Ryb3lpbmdfZWZmZWN0KSB7XG5cdFx0ZS5lZmZlY3RfaW5fdGVhcmRvd24ocnVuZSk7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge0VmZmVjdH0gZWZmZWN0XG4gKiBAcGFyYW0ge0VmZmVjdH0gcGFyZW50X2VmZmVjdFxuICovXG5mdW5jdGlvbiBwdXNoX2VmZmVjdChlZmZlY3QsIHBhcmVudF9lZmZlY3QpIHtcblx0dmFyIHBhcmVudF9sYXN0ID0gcGFyZW50X2VmZmVjdC5sYXN0O1xuXHRpZiAocGFyZW50X2xhc3QgPT09IG51bGwpIHtcblx0XHRwYXJlbnRfZWZmZWN0Lmxhc3QgPSBwYXJlbnRfZWZmZWN0LmZpcnN0ID0gZWZmZWN0O1xuXHR9IGVsc2Uge1xuXHRcdHBhcmVudF9sYXN0Lm5leHQgPSBlZmZlY3Q7XG5cdFx0ZWZmZWN0LnByZXYgPSBwYXJlbnRfbGFzdDtcblx0XHRwYXJlbnRfZWZmZWN0Lmxhc3QgPSBlZmZlY3Q7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge251bWJlcn0gdHlwZVxuICogQHBhcmFtIHtudWxsIHwgKCgpID0+IHZvaWQgfCAoKCkgPT4gdm9pZCkpfSBmblxuICogQHBhcmFtIHtib29sZWFufSBzeW5jXG4gKiBAcGFyYW0ge2Jvb2xlYW59IHB1c2hcbiAqIEByZXR1cm5zIHtFZmZlY3R9XG4gKi9cbmZ1bmN0aW9uIGNyZWF0ZV9lZmZlY3QodHlwZSwgZm4sIHN5bmMsIHB1c2ggPSB0cnVlKSB7XG5cdHZhciBpc19yb290ID0gKHR5cGUgJiBST09UX0VGRkVDVCkgIT09IDA7XG5cdHZhciBwYXJlbnRfZWZmZWN0ID0gYWN0aXZlX2VmZmVjdDtcblxuXHRpZiAoREVWKSB7XG5cdFx0Ly8gRW5zdXJlIHRoZSBwYXJlbnQgaXMgbmV2ZXIgYW4gaW5zcGVjdCBlZmZlY3Rcblx0XHR3aGlsZSAocGFyZW50X2VmZmVjdCAhPT0gbnVsbCAmJiAocGFyZW50X2VmZmVjdC5mICYgSU5TUEVDVF9FRkZFQ1QpICE9PSAwKSB7XG5cdFx0XHRwYXJlbnRfZWZmZWN0ID0gcGFyZW50X2VmZmVjdC5wYXJlbnQ7XG5cdFx0fVxuXHR9XG5cblx0LyoqIEB0eXBlIHtFZmZlY3R9ICovXG5cdHZhciBlZmZlY3QgPSB7XG5cdFx0Y3R4OiBjb21wb25lbnRfY29udGV4dCxcblx0XHRkZXBzOiBudWxsLFxuXHRcdG5vZGVzX3N0YXJ0OiBudWxsLFxuXHRcdG5vZGVzX2VuZDogbnVsbCxcblx0XHRmOiB0eXBlIHwgRElSVFksXG5cdFx0Zmlyc3Q6IG51bGwsXG5cdFx0Zm4sXG5cdFx0bGFzdDogbnVsbCxcblx0XHRuZXh0OiBudWxsLFxuXHRcdHBhcmVudDogaXNfcm9vdCA/IG51bGwgOiBwYXJlbnRfZWZmZWN0LFxuXHRcdHByZXY6IG51bGwsXG5cdFx0dGVhcmRvd246IG51bGwsXG5cdFx0dHJhbnNpdGlvbnM6IG51bGwsXG5cdFx0d3Y6IDBcblx0fTtcblxuXHRpZiAoREVWKSB7XG5cdFx0ZWZmZWN0LmNvbXBvbmVudF9mdW5jdGlvbiA9IGRldl9jdXJyZW50X2NvbXBvbmVudF9mdW5jdGlvbjtcblx0fVxuXG5cdGlmIChzeW5jKSB7XG5cdFx0dmFyIHByZXZpb3VzbHlfZmx1c2hpbmdfZWZmZWN0ID0gaXNfZmx1c2hpbmdfZWZmZWN0O1xuXG5cdFx0dHJ5IHtcblx0XHRcdHNldF9pc19mbHVzaGluZ19lZmZlY3QodHJ1ZSk7XG5cdFx0XHR1cGRhdGVfZWZmZWN0KGVmZmVjdCk7XG5cdFx0XHRlZmZlY3QuZiB8PSBFRkZFQ1RfUkFOO1xuXHRcdH0gY2F0Y2ggKGUpIHtcblx0XHRcdGRlc3Ryb3lfZWZmZWN0KGVmZmVjdCk7XG5cdFx0XHR0aHJvdyBlO1xuXHRcdH0gZmluYWxseSB7XG5cdFx0XHRzZXRfaXNfZmx1c2hpbmdfZWZmZWN0KHByZXZpb3VzbHlfZmx1c2hpbmdfZWZmZWN0KTtcblx0XHR9XG5cdH0gZWxzZSBpZiAoZm4gIT09IG51bGwpIHtcblx0XHRzY2hlZHVsZV9lZmZlY3QoZWZmZWN0KTtcblx0fVxuXG5cdC8vIGlmIGFuIGVmZmVjdCBoYXMgbm8gZGVwZW5kZW5jaWVzLCBubyBET00gYW5kIG5vIHRlYXJkb3duIGZ1bmN0aW9uLFxuXHQvLyBkb24ndCBib3RoZXIgYWRkaW5nIGl0IHRvIHRoZSBlZmZlY3QgdHJlZVxuXHR2YXIgaW5lcnQgPVxuXHRcdHN5bmMgJiZcblx0XHRlZmZlY3QuZGVwcyA9PT0gbnVsbCAmJlxuXHRcdGVmZmVjdC5maXJzdCA9PT0gbnVsbCAmJlxuXHRcdGVmZmVjdC5ub2Rlc19zdGFydCA9PT0gbnVsbCAmJlxuXHRcdGVmZmVjdC50ZWFyZG93biA9PT0gbnVsbCAmJlxuXHRcdChlZmZlY3QuZiAmIChFRkZFQ1RfSEFTX0RFUklWRUQgfCBCT1VOREFSWV9FRkZFQ1QpKSA9PT0gMDtcblxuXHRpZiAoIWluZXJ0ICYmICFpc19yb290ICYmIHB1c2gpIHtcblx0XHRpZiAocGFyZW50X2VmZmVjdCAhPT0gbnVsbCkge1xuXHRcdFx0cHVzaF9lZmZlY3QoZWZmZWN0LCBwYXJlbnRfZWZmZWN0KTtcblx0XHR9XG5cblx0XHQvLyBpZiB3ZSdyZSBpbiBhIGRlcml2ZWQsIGFkZCB0aGUgZWZmZWN0IHRoZXJlIHRvb1xuXHRcdGlmIChhY3RpdmVfcmVhY3Rpb24gIT09IG51bGwgJiYgKGFjdGl2ZV9yZWFjdGlvbi5mICYgREVSSVZFRCkgIT09IDApIHtcblx0XHRcdHZhciBkZXJpdmVkID0gLyoqIEB0eXBlIHtEZXJpdmVkfSAqLyAoYWN0aXZlX3JlYWN0aW9uKTtcblx0XHRcdChkZXJpdmVkLmVmZmVjdHMgPz89IFtdKS5wdXNoKGVmZmVjdCk7XG5cdFx0fVxuXHR9XG5cblx0cmV0dXJuIGVmZmVjdDtcbn1cblxuLyoqXG4gKiBJbnRlcm5hbCByZXByZXNlbnRhdGlvbiBvZiBgJGVmZmVjdC50cmFja2luZygpYFxuICogQHJldHVybnMge2Jvb2xlYW59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBlZmZlY3RfdHJhY2tpbmcoKSB7XG5cdHJldHVybiBhY3RpdmVfcmVhY3Rpb24gIT09IG51bGwgJiYgIXVudHJhY2tpbmc7XG59XG5cbi8qKlxuICogQHBhcmFtIHsoKSA9PiB2b2lkfSBmblxuICovXG5leHBvcnQgZnVuY3Rpb24gdGVhcmRvd24oZm4pIHtcblx0Y29uc3QgZWZmZWN0ID0gY3JlYXRlX2VmZmVjdChSRU5ERVJfRUZGRUNULCBudWxsLCBmYWxzZSk7XG5cdHNldF9zaWduYWxfc3RhdHVzKGVmZmVjdCwgQ0xFQU4pO1xuXHRlZmZlY3QudGVhcmRvd24gPSBmbjtcblx0cmV0dXJuIGVmZmVjdDtcbn1cblxuLyoqXG4gKiBJbnRlcm5hbCByZXByZXNlbnRhdGlvbiBvZiBgJGVmZmVjdCguLi4pYFxuICogQHBhcmFtIHsoKSA9PiB2b2lkIHwgKCgpID0+IHZvaWQpfSBmblxuICovXG5leHBvcnQgZnVuY3Rpb24gdXNlcl9lZmZlY3QoZm4pIHtcblx0dmFsaWRhdGVfZWZmZWN0KCckZWZmZWN0Jyk7XG5cblx0Ly8gTm9uLW5lc3RlZCBgJGVmZmVjdCguLi4pYCBpbiBhIGNvbXBvbmVudCBzaG91bGQgYmUgZGVmZXJyZWRcblx0Ly8gdW50aWwgdGhlIGNvbXBvbmVudCBpcyBtb3VudGVkXG5cdHZhciBkZWZlciA9XG5cdFx0YWN0aXZlX2VmZmVjdCAhPT0gbnVsbCAmJlxuXHRcdChhY3RpdmVfZWZmZWN0LmYgJiBCUkFOQ0hfRUZGRUNUKSAhPT0gMCAmJlxuXHRcdGNvbXBvbmVudF9jb250ZXh0ICE9PSBudWxsICYmXG5cdFx0IWNvbXBvbmVudF9jb250ZXh0Lm07XG5cblx0aWYgKERFVikge1xuXHRcdGRlZmluZV9wcm9wZXJ0eShmbiwgJ25hbWUnLCB7XG5cdFx0XHR2YWx1ZTogJyRlZmZlY3QnXG5cdFx0fSk7XG5cdH1cblxuXHRpZiAoZGVmZXIpIHtcblx0XHR2YXIgY29udGV4dCA9IC8qKiBAdHlwZSB7Q29tcG9uZW50Q29udGV4dH0gKi8gKGNvbXBvbmVudF9jb250ZXh0KTtcblx0XHQoY29udGV4dC5lID8/PSBbXSkucHVzaCh7XG5cdFx0XHRmbixcblx0XHRcdGVmZmVjdDogYWN0aXZlX2VmZmVjdCxcblx0XHRcdHJlYWN0aW9uOiBhY3RpdmVfcmVhY3Rpb25cblx0XHR9KTtcblx0fSBlbHNlIHtcblx0XHR2YXIgc2lnbmFsID0gZWZmZWN0KGZuKTtcblx0XHRyZXR1cm4gc2lnbmFsO1xuXHR9XG59XG5cbi8qKlxuICogSW50ZXJuYWwgcmVwcmVzZW50YXRpb24gb2YgYCRlZmZlY3QucHJlKC4uLilgXG4gKiBAcGFyYW0geygpID0+IHZvaWQgfCAoKCkgPT4gdm9pZCl9IGZuXG4gKiBAcmV0dXJucyB7RWZmZWN0fVxuICovXG5leHBvcnQgZnVuY3Rpb24gdXNlcl9wcmVfZWZmZWN0KGZuKSB7XG5cdHZhbGlkYXRlX2VmZmVjdCgnJGVmZmVjdC5wcmUnKTtcblx0aWYgKERFVikge1xuXHRcdGRlZmluZV9wcm9wZXJ0eShmbiwgJ25hbWUnLCB7XG5cdFx0XHR2YWx1ZTogJyRlZmZlY3QucHJlJ1xuXHRcdH0pO1xuXHR9XG5cdHJldHVybiByZW5kZXJfZWZmZWN0KGZuKTtcbn1cblxuLyoqIEBwYXJhbSB7KCkgPT4gdm9pZCB8ICgoKSA9PiB2b2lkKX0gZm4gKi9cbmV4cG9ydCBmdW5jdGlvbiBpbnNwZWN0X2VmZmVjdChmbikge1xuXHRyZXR1cm4gY3JlYXRlX2VmZmVjdChJTlNQRUNUX0VGRkVDVCwgZm4sIHRydWUpO1xufVxuXG4vKipcbiAqIEludGVybmFsIHJlcHJlc2VudGF0aW9uIG9mIGAkZWZmZWN0LnJvb3QoLi4uKWBcbiAqIEBwYXJhbSB7KCkgPT4gdm9pZCB8ICgoKSA9PiB2b2lkKX0gZm5cbiAqIEByZXR1cm5zIHsoKSA9PiB2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZWZmZWN0X3Jvb3QoZm4pIHtcblx0Y29uc3QgZWZmZWN0ID0gY3JlYXRlX2VmZmVjdChST09UX0VGRkVDVCwgZm4sIHRydWUpO1xuXG5cdHJldHVybiAoKSA9PiB7XG5cdFx0ZGVzdHJveV9lZmZlY3QoZWZmZWN0KTtcblx0fTtcbn1cblxuLyoqXG4gKiBBbiBlZmZlY3Qgcm9vdCB3aG9zZSBjaGlsZHJlbiBjYW4gdHJhbnNpdGlvbiBvdXRcbiAqIEBwYXJhbSB7KCkgPT4gdm9pZH0gZm5cbiAqIEByZXR1cm5zIHsob3B0aW9ucz86IHsgb3V0cm8/OiBib29sZWFuIH0pID0+IFByb21pc2U8dm9pZD59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjb21wb25lbnRfcm9vdChmbikge1xuXHRjb25zdCBlZmZlY3QgPSBjcmVhdGVfZWZmZWN0KFJPT1RfRUZGRUNULCBmbiwgdHJ1ZSk7XG5cblx0cmV0dXJuIChvcHRpb25zID0ge30pID0+IHtcblx0XHRyZXR1cm4gbmV3IFByb21pc2UoKGZ1bGZpbCkgPT4ge1xuXHRcdFx0aWYgKG9wdGlvbnMub3V0cm8pIHtcblx0XHRcdFx0cGF1c2VfZWZmZWN0KGVmZmVjdCwgKCkgPT4ge1xuXHRcdFx0XHRcdGRlc3Ryb3lfZWZmZWN0KGVmZmVjdCk7XG5cdFx0XHRcdFx0ZnVsZmlsKHVuZGVmaW5lZCk7XG5cdFx0XHRcdH0pO1xuXHRcdFx0fSBlbHNlIHtcblx0XHRcdFx0ZGVzdHJveV9lZmZlY3QoZWZmZWN0KTtcblx0XHRcdFx0ZnVsZmlsKHVuZGVmaW5lZCk7XG5cdFx0XHR9XG5cdFx0fSk7XG5cdH07XG59XG5cbi8qKlxuICogQHBhcmFtIHsoKSA9PiB2b2lkIHwgKCgpID0+IHZvaWQpfSBmblxuICogQHJldHVybnMge0VmZmVjdH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGVmZmVjdChmbikge1xuXHRyZXR1cm4gY3JlYXRlX2VmZmVjdChFRkZFQ1QsIGZuLCBmYWxzZSk7XG59XG5cbi8qKlxuICogSW50ZXJuYWwgcmVwcmVzZW50YXRpb24gb2YgYCQ6IC4uYFxuICogQHBhcmFtIHsoKSA9PiBhbnl9IGRlcHNcbiAqIEBwYXJhbSB7KCkgPT4gdm9pZCB8ICgoKSA9PiB2b2lkKX0gZm5cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGxlZ2FjeV9wcmVfZWZmZWN0KGRlcHMsIGZuKSB7XG5cdHZhciBjb250ZXh0ID0gLyoqIEB0eXBlIHtDb21wb25lbnRDb250ZXh0TGVnYWN5fSAqLyAoY29tcG9uZW50X2NvbnRleHQpO1xuXG5cdC8qKiBAdHlwZSB7eyBlZmZlY3Q6IG51bGwgfCBFZmZlY3QsIHJhbjogYm9vbGVhbiB9fSAqL1xuXHR2YXIgdG9rZW4gPSB7IGVmZmVjdDogbnVsbCwgcmFuOiBmYWxzZSB9O1xuXHRjb250ZXh0LmwucjEucHVzaCh0b2tlbik7XG5cblx0dG9rZW4uZWZmZWN0ID0gcmVuZGVyX2VmZmVjdCgoKSA9PiB7XG5cdFx0ZGVwcygpO1xuXG5cdFx0Ly8gSWYgdGhpcyBsZWdhY3kgcHJlIGVmZmVjdCBoYXMgYWxyZWFkeSBydW4gYmVmb3JlIHRoZSBlbmQgb2YgdGhlIHJlc2V0LCB0aGVuXG5cdFx0Ly8gYmFpbCBvdXQgdG8gZW11bGF0ZSB0aGUgc2FtZSBiZWhhdmlvci5cblx0XHRpZiAodG9rZW4ucmFuKSByZXR1cm47XG5cblx0XHR0b2tlbi5yYW4gPSB0cnVlO1xuXHRcdHNldChjb250ZXh0LmwucjIsIHRydWUpO1xuXHRcdHVudHJhY2soZm4pO1xuXHR9KTtcbn1cblxuZXhwb3J0IGZ1bmN0aW9uIGxlZ2FjeV9wcmVfZWZmZWN0X3Jlc2V0KCkge1xuXHR2YXIgY29udGV4dCA9IC8qKiBAdHlwZSB7Q29tcG9uZW50Q29udGV4dExlZ2FjeX0gKi8gKGNvbXBvbmVudF9jb250ZXh0KTtcblxuXHRyZW5kZXJfZWZmZWN0KCgpID0+IHtcblx0XHRpZiAoIWdldChjb250ZXh0LmwucjIpKSByZXR1cm47XG5cblx0XHQvLyBSdW4gZGlydHkgYCQ6YCBzdGF0ZW1lbnRzXG5cdFx0Zm9yICh2YXIgdG9rZW4gb2YgY29udGV4dC5sLnIxKSB7XG5cdFx0XHR2YXIgZWZmZWN0ID0gdG9rZW4uZWZmZWN0O1xuXG5cdFx0XHQvLyBJZiB0aGUgZWZmZWN0IGlzIENMRUFOLCB0aGVuIG1ha2UgaXQgTUFZQkVfRElSVFkuIFRoaXMgZW5zdXJlcyB3ZSB0cmF2ZXJzZSB0aHJvdWdoXG5cdFx0XHQvLyB0aGUgZWZmZWN0cyBkZXBlbmRlbmNpZXMgYW5kIGNvcnJlY3RseSBlbnN1cmUgZWFjaCBkZXBlbmRlbmN5IGlzIHVwLXRvLWRhdGUuXG5cdFx0XHRpZiAoKGVmZmVjdC5mICYgQ0xFQU4pICE9PSAwKSB7XG5cdFx0XHRcdHNldF9zaWduYWxfc3RhdHVzKGVmZmVjdCwgTUFZQkVfRElSVFkpO1xuXHRcdFx0fVxuXG5cdFx0XHRpZiAoY2hlY2tfZGlydGluZXNzKGVmZmVjdCkpIHtcblx0XHRcdFx0dXBkYXRlX2VmZmVjdChlZmZlY3QpO1xuXHRcdFx0fVxuXG5cdFx0XHR0b2tlbi5yYW4gPSBmYWxzZTtcblx0XHR9XG5cblx0XHRjb250ZXh0LmwucjIudiA9IGZhbHNlOyAvLyBzZXQgZGlyZWN0bHkgdG8gYXZvaWQgcmVydW5uaW5nIHRoaXMgZWZmZWN0XG5cdH0pO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7KCkgPT4gdm9pZCB8ICgoKSA9PiB2b2lkKX0gZm5cbiAqIEByZXR1cm5zIHtFZmZlY3R9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiByZW5kZXJfZWZmZWN0KGZuKSB7XG5cdHJldHVybiBjcmVhdGVfZWZmZWN0KFJFTkRFUl9FRkZFQ1QsIGZuLCB0cnVlKTtcbn1cblxuLyoqXG4gKiBAcGFyYW0geyguLi5leHByZXNzaW9uczogYW55KSA9PiB2b2lkIHwgKCgpID0+IHZvaWQpfSBmblxuICogQHBhcmFtIHtBcnJheTwoKSA9PiBhbnk+fSB0aHVua3NcbiAqIEByZXR1cm5zIHtFZmZlY3R9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiB0ZW1wbGF0ZV9lZmZlY3QoZm4sIHRodW5rcyA9IFtdLCBkID0gZGVyaXZlZCkge1xuXHRjb25zdCBkZXJpdmVkcyA9IHRodW5rcy5tYXAoZCk7XG5cdGNvbnN0IGVmZmVjdCA9ICgpID0+IGZuKC4uLmRlcml2ZWRzLm1hcChnZXQpKTtcblxuXHRpZiAoREVWKSB7XG5cdFx0ZGVmaW5lX3Byb3BlcnR5KGVmZmVjdCwgJ25hbWUnLCB7XG5cdFx0XHR2YWx1ZTogJ3tleHByZXNzaW9ufSdcblx0XHR9KTtcblx0fVxuXG5cdHJldHVybiBibG9jayhlZmZlY3QpO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7KCgpID0+IHZvaWQpfSBmblxuICogQHBhcmFtIHtudW1iZXJ9IGZsYWdzXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBibG9jayhmbiwgZmxhZ3MgPSAwKSB7XG5cdHJldHVybiBjcmVhdGVfZWZmZWN0KFJFTkRFUl9FRkZFQ1QgfCBCTE9DS19FRkZFQ1QgfCBmbGFncywgZm4sIHRydWUpO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7KCgpID0+IHZvaWQpfSBmblxuICogQHBhcmFtIHtib29sZWFufSBbcHVzaF1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGJyYW5jaChmbiwgcHVzaCA9IHRydWUpIHtcblx0cmV0dXJuIGNyZWF0ZV9lZmZlY3QoUkVOREVSX0VGRkVDVCB8IEJSQU5DSF9FRkZFQ1QsIGZuLCB0cnVlLCBwdXNoKTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge0VmZmVjdH0gZWZmZWN0XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBleGVjdXRlX2VmZmVjdF90ZWFyZG93bihlZmZlY3QpIHtcblx0dmFyIHRlYXJkb3duID0gZWZmZWN0LnRlYXJkb3duO1xuXHRpZiAodGVhcmRvd24gIT09IG51bGwpIHtcblx0XHRjb25zdCBwcmV2aW91c2x5X2Rlc3Ryb3lpbmdfZWZmZWN0ID0gaXNfZGVzdHJveWluZ19lZmZlY3Q7XG5cdFx0Y29uc3QgcHJldmlvdXNfcmVhY3Rpb24gPSBhY3RpdmVfcmVhY3Rpb247XG5cdFx0c2V0X2lzX2Rlc3Ryb3lpbmdfZWZmZWN0KHRydWUpO1xuXHRcdHNldF9hY3RpdmVfcmVhY3Rpb24obnVsbCk7XG5cdFx0dHJ5IHtcblx0XHRcdHRlYXJkb3duLmNhbGwobnVsbCk7XG5cdFx0fSBmaW5hbGx5IHtcblx0XHRcdHNldF9pc19kZXN0cm95aW5nX2VmZmVjdChwcmV2aW91c2x5X2Rlc3Ryb3lpbmdfZWZmZWN0KTtcblx0XHRcdHNldF9hY3RpdmVfcmVhY3Rpb24ocHJldmlvdXNfcmVhY3Rpb24pO1xuXHRcdH1cblx0fVxufVxuXG4vKipcbiAqIEBwYXJhbSB7RWZmZWN0fSBzaWduYWxcbiAqIEBwYXJhbSB7Ym9vbGVhbn0gcmVtb3ZlX2RvbVxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBkZXN0cm95X2VmZmVjdF9jaGlsZHJlbihzaWduYWwsIHJlbW92ZV9kb20gPSBmYWxzZSkge1xuXHR2YXIgZWZmZWN0ID0gc2lnbmFsLmZpcnN0O1xuXHRzaWduYWwuZmlyc3QgPSBzaWduYWwubGFzdCA9IG51bGw7XG5cblx0d2hpbGUgKGVmZmVjdCAhPT0gbnVsbCkge1xuXHRcdHZhciBuZXh0ID0gZWZmZWN0Lm5leHQ7XG5cdFx0ZGVzdHJveV9lZmZlY3QoZWZmZWN0LCByZW1vdmVfZG9tKTtcblx0XHRlZmZlY3QgPSBuZXh0O1xuXHR9XG59XG5cbi8qKlxuICogQHBhcmFtIHtFZmZlY3R9IHNpZ25hbFxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBkZXN0cm95X2Jsb2NrX2VmZmVjdF9jaGlsZHJlbihzaWduYWwpIHtcblx0dmFyIGVmZmVjdCA9IHNpZ25hbC5maXJzdDtcblxuXHR3aGlsZSAoZWZmZWN0ICE9PSBudWxsKSB7XG5cdFx0dmFyIG5leHQgPSBlZmZlY3QubmV4dDtcblx0XHRpZiAoKGVmZmVjdC5mICYgQlJBTkNIX0VGRkVDVCkgPT09IDApIHtcblx0XHRcdGRlc3Ryb3lfZWZmZWN0KGVmZmVjdCk7XG5cdFx0fVxuXHRcdGVmZmVjdCA9IG5leHQ7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge0VmZmVjdH0gZWZmZWN0XG4gKiBAcGFyYW0ge2Jvb2xlYW59IFtyZW1vdmVfZG9tXVxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBkZXN0cm95X2VmZmVjdChlZmZlY3QsIHJlbW92ZV9kb20gPSB0cnVlKSB7XG5cdHZhciByZW1vdmVkID0gZmFsc2U7XG5cblx0aWYgKChyZW1vdmVfZG9tIHx8IChlZmZlY3QuZiAmIEhFQURfRUZGRUNUKSAhPT0gMCkgJiYgZWZmZWN0Lm5vZGVzX3N0YXJ0ICE9PSBudWxsKSB7XG5cdFx0LyoqIEB0eXBlIHtUZW1wbGF0ZU5vZGUgfCBudWxsfSAqL1xuXHRcdHZhciBub2RlID0gZWZmZWN0Lm5vZGVzX3N0YXJ0O1xuXHRcdHZhciBlbmQgPSBlZmZlY3Qubm9kZXNfZW5kO1xuXG5cdFx0d2hpbGUgKG5vZGUgIT09IG51bGwpIHtcblx0XHRcdC8qKiBAdHlwZSB7VGVtcGxhdGVOb2RlIHwgbnVsbH0gKi9cblx0XHRcdHZhciBuZXh0ID0gbm9kZSA9PT0gZW5kID8gbnVsbCA6IC8qKiBAdHlwZSB7VGVtcGxhdGVOb2RlfSAqLyAoZ2V0X25leHRfc2libGluZyhub2RlKSk7XG5cblx0XHRcdG5vZGUucmVtb3ZlKCk7XG5cdFx0XHRub2RlID0gbmV4dDtcblx0XHR9XG5cblx0XHRyZW1vdmVkID0gdHJ1ZTtcblx0fVxuXG5cdGRlc3Ryb3lfZWZmZWN0X2NoaWxkcmVuKGVmZmVjdCwgcmVtb3ZlX2RvbSAmJiAhcmVtb3ZlZCk7XG5cdHJlbW92ZV9yZWFjdGlvbnMoZWZmZWN0LCAwKTtcblx0c2V0X3NpZ25hbF9zdGF0dXMoZWZmZWN0LCBERVNUUk9ZRUQpO1xuXG5cdHZhciB0cmFuc2l0aW9ucyA9IGVmZmVjdC50cmFuc2l0aW9ucztcblxuXHRpZiAodHJhbnNpdGlvbnMgIT09IG51bGwpIHtcblx0XHRmb3IgKGNvbnN0IHRyYW5zaXRpb24gb2YgdHJhbnNpdGlvbnMpIHtcblx0XHRcdHRyYW5zaXRpb24uc3RvcCgpO1xuXHRcdH1cblx0fVxuXG5cdGV4ZWN1dGVfZWZmZWN0X3RlYXJkb3duKGVmZmVjdCk7XG5cblx0dmFyIHBhcmVudCA9IGVmZmVjdC5wYXJlbnQ7XG5cblx0Ly8gSWYgdGhlIHBhcmVudCBkb2Vzbid0IGhhdmUgYW55IGNoaWxkcmVuLCB0aGVuIHNraXAgdGhpcyB3b3JrIGFsdG9nZXRoZXJcblx0aWYgKHBhcmVudCAhPT0gbnVsbCAmJiBwYXJlbnQuZmlyc3QgIT09IG51bGwpIHtcblx0XHR1bmxpbmtfZWZmZWN0KGVmZmVjdCk7XG5cdH1cblxuXHRpZiAoREVWKSB7XG5cdFx0ZWZmZWN0LmNvbXBvbmVudF9mdW5jdGlvbiA9IG51bGw7XG5cdH1cblxuXHQvLyBgZmlyc3RgIGFuZCBgY2hpbGRgIGFyZSBudWxsZWQgb3V0IGluIGRlc3Ryb3lfZWZmZWN0X2NoaWxkcmVuXG5cdC8vIHdlIGRvbid0IG51bGwgb3V0IGBwYXJlbnRgIHNvIHRoYXQgZXJyb3IgcHJvcGFnYXRpb24gY2FuIHdvcmsgY29ycmVjdGx5XG5cdGVmZmVjdC5uZXh0ID1cblx0XHRlZmZlY3QucHJldiA9XG5cdFx0ZWZmZWN0LnRlYXJkb3duID1cblx0XHRlZmZlY3QuY3R4ID1cblx0XHRlZmZlY3QuZGVwcyA9XG5cdFx0ZWZmZWN0LmZuID1cblx0XHRlZmZlY3Qubm9kZXNfc3RhcnQgPVxuXHRcdGVmZmVjdC5ub2Rlc19lbmQgPVxuXHRcdFx0bnVsbDtcbn1cblxuLyoqXG4gKiBEZXRhY2ggYW4gZWZmZWN0IGZyb20gdGhlIGVmZmVjdCB0cmVlLCBmcmVlaW5nIHVwIG1lbW9yeSBhbmRcbiAqIHJlZHVjaW5nIHRoZSBhbW91bnQgb2Ygd29yayB0aGF0IGhhcHBlbnMgb24gc3Vic2VxdWVudCB0cmF2ZXJzYWxzXG4gKiBAcGFyYW0ge0VmZmVjdH0gZWZmZWN0XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiB1bmxpbmtfZWZmZWN0KGVmZmVjdCkge1xuXHR2YXIgcGFyZW50ID0gZWZmZWN0LnBhcmVudDtcblx0dmFyIHByZXYgPSBlZmZlY3QucHJldjtcblx0dmFyIG5leHQgPSBlZmZlY3QubmV4dDtcblxuXHRpZiAocHJldiAhPT0gbnVsbCkgcHJldi5uZXh0ID0gbmV4dDtcblx0aWYgKG5leHQgIT09IG51bGwpIG5leHQucHJldiA9IHByZXY7XG5cblx0aWYgKHBhcmVudCAhPT0gbnVsbCkge1xuXHRcdGlmIChwYXJlbnQuZmlyc3QgPT09IGVmZmVjdCkgcGFyZW50LmZpcnN0ID0gbmV4dDtcblx0XHRpZiAocGFyZW50Lmxhc3QgPT09IGVmZmVjdCkgcGFyZW50Lmxhc3QgPSBwcmV2O1xuXHR9XG59XG5cbi8qKlxuICogV2hlbiBhIGJsb2NrIGVmZmVjdCBpcyByZW1vdmVkLCB3ZSBkb24ndCBpbW1lZGlhdGVseSBkZXN0cm95IGl0IG9yIHlhbmsgaXRcbiAqIG91dCBvZiB0aGUgRE9NLCBiZWNhdXNlIGl0IG1pZ2h0IGhhdmUgdHJhbnNpdGlvbnMuIEluc3RlYWQsIHdlICdwYXVzZScgaXQuXG4gKiBJdCBzdGF5cyBhcm91bmQgKGluIG1lbW9yeSwgYW5kIGluIHRoZSBET00pIHVudGlsIG91dHJvIHRyYW5zaXRpb25zIGhhdmVcbiAqIGNvbXBsZXRlZCwgYW5kIGlmIHRoZSBzdGF0ZSBjaGFuZ2UgaXMgcmV2ZXJzZWQgdGhlbiB3ZSBfcmVzdW1lXyBpdC5cbiAqIEEgcGF1c2VkIGVmZmVjdCBkb2VzIG5vdCB1cGRhdGUsIGFuZCB0aGUgRE9NIHN1YnRyZWUgYmVjb21lcyBpbmVydC5cbiAqIEBwYXJhbSB7RWZmZWN0fSBlZmZlY3RcbiAqIEBwYXJhbSB7KCkgPT4gdm9pZH0gW2NhbGxiYWNrXVxuICovXG5leHBvcnQgZnVuY3Rpb24gcGF1c2VfZWZmZWN0KGVmZmVjdCwgY2FsbGJhY2spIHtcblx0LyoqIEB0eXBlIHtUcmFuc2l0aW9uTWFuYWdlcltdfSAqL1xuXHR2YXIgdHJhbnNpdGlvbnMgPSBbXTtcblxuXHRwYXVzZV9jaGlsZHJlbihlZmZlY3QsIHRyYW5zaXRpb25zLCB0cnVlKTtcblxuXHRydW5fb3V0X3RyYW5zaXRpb25zKHRyYW5zaXRpb25zLCAoKSA9PiB7XG5cdFx0ZGVzdHJveV9lZmZlY3QoZWZmZWN0KTtcblx0XHRpZiAoY2FsbGJhY2spIGNhbGxiYWNrKCk7XG5cdH0pO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7VHJhbnNpdGlvbk1hbmFnZXJbXX0gdHJhbnNpdGlvbnNcbiAqIEBwYXJhbSB7KCkgPT4gdm9pZH0gZm5cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHJ1bl9vdXRfdHJhbnNpdGlvbnModHJhbnNpdGlvbnMsIGZuKSB7XG5cdHZhciByZW1haW5pbmcgPSB0cmFuc2l0aW9ucy5sZW5ndGg7XG5cdGlmIChyZW1haW5pbmcgPiAwKSB7XG5cdFx0dmFyIGNoZWNrID0gKCkgPT4gLS1yZW1haW5pbmcgfHwgZm4oKTtcblx0XHRmb3IgKHZhciB0cmFuc2l0aW9uIG9mIHRyYW5zaXRpb25zKSB7XG5cdFx0XHR0cmFuc2l0aW9uLm91dChjaGVjayk7XG5cdFx0fVxuXHR9IGVsc2Uge1xuXHRcdGZuKCk7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge0VmZmVjdH0gZWZmZWN0XG4gKiBAcGFyYW0ge1RyYW5zaXRpb25NYW5hZ2VyW119IHRyYW5zaXRpb25zXG4gKiBAcGFyYW0ge2Jvb2xlYW59IGxvY2FsXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBwYXVzZV9jaGlsZHJlbihlZmZlY3QsIHRyYW5zaXRpb25zLCBsb2NhbCkge1xuXHRpZiAoKGVmZmVjdC5mICYgSU5FUlQpICE9PSAwKSByZXR1cm47XG5cdGVmZmVjdC5mIF49IElORVJUO1xuXG5cdGlmIChlZmZlY3QudHJhbnNpdGlvbnMgIT09IG51bGwpIHtcblx0XHRmb3IgKGNvbnN0IHRyYW5zaXRpb24gb2YgZWZmZWN0LnRyYW5zaXRpb25zKSB7XG5cdFx0XHRpZiAodHJhbnNpdGlvbi5pc19nbG9iYWwgfHwgbG9jYWwpIHtcblx0XHRcdFx0dHJhbnNpdGlvbnMucHVzaCh0cmFuc2l0aW9uKTtcblx0XHRcdH1cblx0XHR9XG5cdH1cblxuXHR2YXIgY2hpbGQgPSBlZmZlY3QuZmlyc3Q7XG5cblx0d2hpbGUgKGNoaWxkICE9PSBudWxsKSB7XG5cdFx0dmFyIHNpYmxpbmcgPSBjaGlsZC5uZXh0O1xuXHRcdHZhciB0cmFuc3BhcmVudCA9IChjaGlsZC5mICYgRUZGRUNUX1RSQU5TUEFSRU5UKSAhPT0gMCB8fCAoY2hpbGQuZiAmIEJSQU5DSF9FRkZFQ1QpICE9PSAwO1xuXHRcdC8vIFRPRE8gd2UgZG9uJ3QgbmVlZCB0byBjYWxsIHBhdXNlX2NoaWxkcmVuIHJlY3Vyc2l2ZWx5IHdpdGggYSBsaW5rZWQgbGlzdCBpbiBwbGFjZVxuXHRcdC8vIGl0J3Mgc2xpZ2h0bHkgbW9yZSBpbnZvbHZlZCB0aG91Z2ggYXMgd2UgaGF2ZSB0byBhY2NvdW50IGZvciBgdHJhbnNwYXJlbnRgIGNoYW5naW5nXG5cdFx0Ly8gdGhyb3VnaCB0aGUgdHJlZS5cblx0XHRwYXVzZV9jaGlsZHJlbihjaGlsZCwgdHJhbnNpdGlvbnMsIHRyYW5zcGFyZW50ID8gbG9jYWwgOiBmYWxzZSk7XG5cdFx0Y2hpbGQgPSBzaWJsaW5nO1xuXHR9XG59XG5cbi8qKlxuICogVGhlIG9wcG9zaXRlIG9mIGBwYXVzZV9lZmZlY3RgLiBXZSBjYWxsIHRoaXMgaWYgKGZvciBleGFtcGxlKVxuICogYHhgIGJlY29tZXMgZmFsc3kgdGhlbiB0cnV0aHk6IGB7I2lmIHh9Li4uey9pZn1gXG4gKiBAcGFyYW0ge0VmZmVjdH0gZWZmZWN0XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiByZXN1bWVfZWZmZWN0KGVmZmVjdCkge1xuXHRyZXN1bWVfY2hpbGRyZW4oZWZmZWN0LCB0cnVlKTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge0VmZmVjdH0gZWZmZWN0XG4gKiBAcGFyYW0ge2Jvb2xlYW59IGxvY2FsXG4gKi9cbmZ1bmN0aW9uIHJlc3VtZV9jaGlsZHJlbihlZmZlY3QsIGxvY2FsKSB7XG5cdGlmICgoZWZmZWN0LmYgJiBJTkVSVCkgPT09IDApIHJldHVybjtcblx0ZWZmZWN0LmYgXj0gSU5FUlQ7XG5cblx0Ly8gRW5zdXJlIHRoZSBlZmZlY3QgaXMgbWFya2VkIGFzIGNsZWFuIGFnYWluIHNvIHRoYXQgYW55IGRpcnR5IGNoaWxkXG5cdC8vIGVmZmVjdHMgY2FuIHNjaGVkdWxlIHRoZW1zZWx2ZXMgZm9yIGV4ZWN1dGlvblxuXHRpZiAoKGVmZmVjdC5mICYgQ0xFQU4pID09PSAwKSB7XG5cdFx0ZWZmZWN0LmYgXj0gQ0xFQU47XG5cdH1cblxuXHQvLyBJZiBhIGRlcGVuZGVuY3kgb2YgdGhpcyBlZmZlY3QgY2hhbmdlZCB3aGlsZSBpdCB3YXMgcGF1c2VkLFxuXHQvLyBzY2hlZHVsZSB0aGUgZWZmZWN0IHRvIHVwZGF0ZVxuXHRpZiAoY2hlY2tfZGlydGluZXNzKGVmZmVjdCkpIHtcblx0XHRzZXRfc2lnbmFsX3N0YXR1cyhlZmZlY3QsIERJUlRZKTtcblx0XHRzY2hlZHVsZV9lZmZlY3QoZWZmZWN0KTtcblx0fVxuXG5cdHZhciBjaGlsZCA9IGVmZmVjdC5maXJzdDtcblxuXHR3aGlsZSAoY2hpbGQgIT09IG51bGwpIHtcblx0XHR2YXIgc2libGluZyA9IGNoaWxkLm5leHQ7XG5cdFx0dmFyIHRyYW5zcGFyZW50ID0gKGNoaWxkLmYgJiBFRkZFQ1RfVFJBTlNQQVJFTlQpICE9PSAwIHx8IChjaGlsZC5mICYgQlJBTkNIX0VGRkVDVCkgIT09IDA7XG5cdFx0Ly8gVE9ETyB3ZSBkb24ndCBuZWVkIHRvIGNhbGwgcmVzdW1lX2NoaWxkcmVuIHJlY3Vyc2l2ZWx5IHdpdGggYSBsaW5rZWQgbGlzdCBpbiBwbGFjZVxuXHRcdC8vIGl0J3Mgc2xpZ2h0bHkgbW9yZSBpbnZvbHZlZCB0aG91Z2ggYXMgd2UgaGF2ZSB0byBhY2NvdW50IGZvciBgdHJhbnNwYXJlbnRgIGNoYW5naW5nXG5cdFx0Ly8gdGhyb3VnaCB0aGUgdHJlZS5cblx0XHRyZXN1bWVfY2hpbGRyZW4oY2hpbGQsIHRyYW5zcGFyZW50ID8gbG9jYWwgOiBmYWxzZSk7XG5cdFx0Y2hpbGQgPSBzaWJsaW5nO1xuXHR9XG5cblx0aWYgKGVmZmVjdC50cmFuc2l0aW9ucyAhPT0gbnVsbCkge1xuXHRcdGZvciAoY29uc3QgdHJhbnNpdGlvbiBvZiBlZmZlY3QudHJhbnNpdGlvbnMpIHtcblx0XHRcdGlmICh0cmFuc2l0aW9uLmlzX2dsb2JhbCB8fCBsb2NhbCkge1xuXHRcdFx0XHR0cmFuc2l0aW9uLmluKCk7XG5cdFx0XHR9XG5cdFx0fVxuXHR9XG59XG4iLCAiaW1wb3J0IHsgcnVuX2FsbCB9IGZyb20gJy4uLy4uL3NoYXJlZC91dGlscy5qcyc7XG5cbi8vIEZhbGxiYWNrIGZvciB3aGVuIHJlcXVlc3RJZGxlQ2FsbGJhY2sgaXMgbm90IGF2YWlsYWJsZVxuZXhwb3J0IGNvbnN0IHJlcXVlc3RfaWRsZV9jYWxsYmFjayA9XG5cdHR5cGVvZiByZXF1ZXN0SWRsZUNhbGxiYWNrID09PSAndW5kZWZpbmVkJ1xuXHRcdD8gKC8qKiBAdHlwZSB7KCkgPT4gdm9pZH0gKi8gY2IpID0+IHNldFRpbWVvdXQoY2IsIDEpXG5cdFx0OiByZXF1ZXN0SWRsZUNhbGxiYWNrO1xuXG5sZXQgaXNfbWljcm9fdGFza19xdWV1ZWQgPSBmYWxzZTtcbmxldCBpc19pZGxlX3Rhc2tfcXVldWVkID0gZmFsc2U7XG5cbi8qKiBAdHlwZSB7QXJyYXk8KCkgPT4gdm9pZD59ICovXG5sZXQgY3VycmVudF9xdWV1ZWRfbWljcm9fdGFza3MgPSBbXTtcbi8qKiBAdHlwZSB7QXJyYXk8KCkgPT4gdm9pZD59ICovXG5sZXQgY3VycmVudF9xdWV1ZWRfaWRsZV90YXNrcyA9IFtdO1xuXG5mdW5jdGlvbiBwcm9jZXNzX21pY3JvX3Rhc2tzKCkge1xuXHRpc19taWNyb190YXNrX3F1ZXVlZCA9IGZhbHNlO1xuXHRjb25zdCB0YXNrcyA9IGN1cnJlbnRfcXVldWVkX21pY3JvX3Rhc2tzLnNsaWNlKCk7XG5cdGN1cnJlbnRfcXVldWVkX21pY3JvX3Rhc2tzID0gW107XG5cdHJ1bl9hbGwodGFza3MpO1xufVxuXG5mdW5jdGlvbiBwcm9jZXNzX2lkbGVfdGFza3MoKSB7XG5cdGlzX2lkbGVfdGFza19xdWV1ZWQgPSBmYWxzZTtcblx0Y29uc3QgdGFza3MgPSBjdXJyZW50X3F1ZXVlZF9pZGxlX3Rhc2tzLnNsaWNlKCk7XG5cdGN1cnJlbnRfcXVldWVkX2lkbGVfdGFza3MgPSBbXTtcblx0cnVuX2FsbCh0YXNrcyk7XG59XG5cbi8qKlxuICogQHBhcmFtIHsoKSA9PiB2b2lkfSBmblxuICovXG5leHBvcnQgZnVuY3Rpb24gcXVldWVfbWljcm9fdGFzayhmbikge1xuXHRpZiAoIWlzX21pY3JvX3Rhc2tfcXVldWVkKSB7XG5cdFx0aXNfbWljcm9fdGFza19xdWV1ZWQgPSB0cnVlO1xuXHRcdHF1ZXVlTWljcm90YXNrKHByb2Nlc3NfbWljcm9fdGFza3MpO1xuXHR9XG5cdGN1cnJlbnRfcXVldWVkX21pY3JvX3Rhc2tzLnB1c2goZm4pO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7KCkgPT4gdm9pZH0gZm5cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHF1ZXVlX2lkbGVfdGFzayhmbikge1xuXHRpZiAoIWlzX2lkbGVfdGFza19xdWV1ZWQpIHtcblx0XHRpc19pZGxlX3Rhc2tfcXVldWVkID0gdHJ1ZTtcblx0XHRyZXF1ZXN0X2lkbGVfY2FsbGJhY2socHJvY2Vzc19pZGxlX3Rhc2tzKTtcblx0fVxuXHRjdXJyZW50X3F1ZXVlZF9pZGxlX3Rhc2tzLnB1c2goZm4pO1xufVxuXG4vKipcbiAqIFN5bmNocm9ub3VzbHkgcnVuIGFueSBxdWV1ZWQgdGFza3MuXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBmbHVzaF90YXNrcygpIHtcblx0aWYgKGlzX21pY3JvX3Rhc2tfcXVldWVkKSB7XG5cdFx0cHJvY2Vzc19taWNyb190YXNrcygpO1xuXHR9XG5cdGlmIChpc19pZGxlX3Rhc2tfcXVldWVkKSB7XG5cdFx0cHJvY2Vzc19pZGxlX3Rhc2tzKCk7XG5cdH1cbn1cbiIsICIvKiogQGltcG9ydCB7IENvbXBvbmVudENvbnRleHQsIERlcml2ZWQsIEVmZmVjdCwgUmVhY3Rpb24sIFNpZ25hbCwgU291cmNlLCBWYWx1ZSB9IGZyb20gJyNjbGllbnQnICovXG5pbXBvcnQgeyBERVYgfSBmcm9tICdlc20tZW52JztcbmltcG9ydCB7IGRlZmluZV9wcm9wZXJ0eSwgZ2V0X2Rlc2NyaXB0b3JzLCBnZXRfcHJvdG90eXBlX29mLCBpbmRleF9vZiB9IGZyb20gJy4uL3NoYXJlZC91dGlscy5qcyc7XG5pbXBvcnQge1xuXHRkZXN0cm95X2Jsb2NrX2VmZmVjdF9jaGlsZHJlbixcblx0ZGVzdHJveV9lZmZlY3RfY2hpbGRyZW4sXG5cdGV4ZWN1dGVfZWZmZWN0X3RlYXJkb3duLFxuXHR1bmxpbmtfZWZmZWN0XG59IGZyb20gJy4vcmVhY3Rpdml0eS9lZmZlY3RzLmpzJztcbmltcG9ydCB7XG5cdEVGRkVDVCxcblx0UkVOREVSX0VGRkVDVCxcblx0RElSVFksXG5cdE1BWUJFX0RJUlRZLFxuXHRDTEVBTixcblx0REVSSVZFRCxcblx0VU5PV05FRCxcblx0REVTVFJPWUVELFxuXHRJTkVSVCxcblx0QlJBTkNIX0VGRkVDVCxcblx0U1RBVEVfU1lNQk9MLFxuXHRCTE9DS19FRkZFQ1QsXG5cdFJPT1RfRUZGRUNULFxuXHRMRUdBQ1lfREVSSVZFRF9QUk9QLFxuXHRESVNDT05ORUNURUQsXG5cdEJPVU5EQVJZX0VGRkVDVFxufSBmcm9tICcuL2NvbnN0YW50cy5qcyc7XG5pbXBvcnQgeyBmbHVzaF90YXNrcyB9IGZyb20gJy4vZG9tL3Rhc2suanMnO1xuaW1wb3J0IHsgaW50ZXJuYWxfc2V0IH0gZnJvbSAnLi9yZWFjdGl2aXR5L3NvdXJjZXMuanMnO1xuaW1wb3J0IHsgZGVzdHJveV9kZXJpdmVkX2VmZmVjdHMsIHVwZGF0ZV9kZXJpdmVkIH0gZnJvbSAnLi9yZWFjdGl2aXR5L2Rlcml2ZWRzLmpzJztcbmltcG9ydCAqIGFzIGUgZnJvbSAnLi9lcnJvcnMuanMnO1xuaW1wb3J0IHsgRklMRU5BTUUgfSBmcm9tICcuLi8uLi9jb25zdGFudHMuanMnO1xuaW1wb3J0IHsgdHJhY2luZ19tb2RlX2ZsYWcgfSBmcm9tICcuLi9mbGFncy9pbmRleC5qcyc7XG5pbXBvcnQgeyB0cmFjaW5nX2V4cHJlc3Npb25zLCBnZXRfc3RhY2sgfSBmcm9tICcuL2Rldi90cmFjaW5nLmpzJztcbmltcG9ydCB7XG5cdGNvbXBvbmVudF9jb250ZXh0LFxuXHRkZXZfY3VycmVudF9jb21wb25lbnRfZnVuY3Rpb24sXG5cdGlzX3J1bmVzLFxuXHRzZXRfY29tcG9uZW50X2NvbnRleHQsXG5cdHNldF9kZXZfY3VycmVudF9jb21wb25lbnRfZnVuY3Rpb25cbn0gZnJvbSAnLi9jb250ZXh0LmpzJztcbmltcG9ydCB7IGlzX2ZpcmVmb3ggfSBmcm9tICcuL2RvbS9vcGVyYXRpb25zLmpzJztcblxuY29uc3QgRkxVU0hfTUlDUk9UQVNLID0gMDtcbmNvbnN0IEZMVVNIX1NZTkMgPSAxO1xuLy8gVXNlZCBmb3IgREVWIHRpbWUgZXJyb3IgaGFuZGxpbmdcbi8qKiBAcGFyYW0ge1dlYWtTZXQ8RXJyb3I+fSB2YWx1ZSAqL1xuY29uc3QgaGFuZGxlZF9lcnJvcnMgPSBuZXcgV2Vha1NldCgpO1xuZXhwb3J0IGxldCBpc190aHJvd2luZ19lcnJvciA9IGZhbHNlO1xuXG4vLyBVc2VkIGZvciBjb250cm9sbGluZyB0aGUgZmx1c2ggb2YgZWZmZWN0cy5cbmxldCBzY2hlZHVsZXJfbW9kZSA9IEZMVVNIX01JQ1JPVEFTSztcbi8vIFVzZWQgZm9yIGhhbmRsaW5nIHNjaGVkdWxpbmdcbmxldCBpc19taWNyb190YXNrX3F1ZXVlZCA9IGZhbHNlO1xuXG4vKiogQHR5cGUge0VmZmVjdCB8IG51bGx9ICovXG5sZXQgbGFzdF9zY2hlZHVsZWRfZWZmZWN0ID0gbnVsbDtcblxuZXhwb3J0IGxldCBpc19mbHVzaGluZ19lZmZlY3QgPSBmYWxzZTtcbmV4cG9ydCBsZXQgaXNfZGVzdHJveWluZ19lZmZlY3QgPSBmYWxzZTtcblxuLyoqIEBwYXJhbSB7Ym9vbGVhbn0gdmFsdWUgKi9cbmV4cG9ydCBmdW5jdGlvbiBzZXRfaXNfZmx1c2hpbmdfZWZmZWN0KHZhbHVlKSB7XG5cdGlzX2ZsdXNoaW5nX2VmZmVjdCA9IHZhbHVlO1xufVxuXG4vKiogQHBhcmFtIHtib29sZWFufSB2YWx1ZSAqL1xuZXhwb3J0IGZ1bmN0aW9uIHNldF9pc19kZXN0cm95aW5nX2VmZmVjdCh2YWx1ZSkge1xuXHRpc19kZXN0cm95aW5nX2VmZmVjdCA9IHZhbHVlO1xufVxuXG4vLyBIYW5kbGUgZWZmZWN0IHF1ZXVlc1xuXG4vKiogQHR5cGUge0VmZmVjdFtdfSAqL1xubGV0IHF1ZXVlZF9yb290X2VmZmVjdHMgPSBbXTtcblxubGV0IGZsdXNoX2NvdW50ID0gMDtcbi8qKiBAdHlwZSB7RWZmZWN0W119IFN0YWNrIG9mIGVmZmVjdHMsIGRldiBvbmx5ICovXG5sZXQgZGV2X2VmZmVjdF9zdGFjayA9IFtdO1xuLy8gSGFuZGxlIHNpZ25hbCByZWFjdGl2aXR5IHRyZWUgZGVwZW5kZW5jaWVzIGFuZCByZWFjdGlvbnNcblxuLyoqIEB0eXBlIHtudWxsIHwgUmVhY3Rpb259ICovXG5leHBvcnQgbGV0IGFjdGl2ZV9yZWFjdGlvbiA9IG51bGw7XG5cbmV4cG9ydCBsZXQgdW50cmFja2luZyA9IGZhbHNlO1xuXG4vKiogQHBhcmFtIHtudWxsIHwgUmVhY3Rpb259IHJlYWN0aW9uICovXG5leHBvcnQgZnVuY3Rpb24gc2V0X2FjdGl2ZV9yZWFjdGlvbihyZWFjdGlvbikge1xuXHRhY3RpdmVfcmVhY3Rpb24gPSByZWFjdGlvbjtcbn1cblxuLyoqIEB0eXBlIHtudWxsIHwgRWZmZWN0fSAqL1xuZXhwb3J0IGxldCBhY3RpdmVfZWZmZWN0ID0gbnVsbDtcblxuLyoqIEBwYXJhbSB7bnVsbCB8IEVmZmVjdH0gZWZmZWN0ICovXG5leHBvcnQgZnVuY3Rpb24gc2V0X2FjdGl2ZV9lZmZlY3QoZWZmZWN0KSB7XG5cdGFjdGl2ZV9lZmZlY3QgPSBlZmZlY3Q7XG59XG5cbi8qKlxuICogV2hlbiBzb3VyY2VzIGFyZSBjcmVhdGVkIHdpdGhpbiBhIGRlcml2ZWQsIHdlIHJlY29yZCB0aGVtIHNvIHRoYXQgd2UgY2FuIHNhZmVseSBhbGxvd1xuICogbG9jYWwgbXV0YXRpb25zIHRvIHRoZXNlIHNvdXJjZXMgd2l0aG91dCB0aGUgc2lkZS1lZmZlY3QgZXJyb3IgYmVpbmcgaW52b2tlZCB1bm5lY2Vzc2FyaWx5LlxuICogQHR5cGUge251bGwgfCBTb3VyY2VbXX1cbiAqL1xuZXhwb3J0IGxldCBkZXJpdmVkX3NvdXJjZXMgPSBudWxsO1xuXG4vKipcbiAqIEBwYXJhbSB7U291cmNlW10gfCBudWxsfSBzb3VyY2VzXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzZXRfZGVyaXZlZF9zb3VyY2VzKHNvdXJjZXMpIHtcblx0ZGVyaXZlZF9zb3VyY2VzID0gc291cmNlcztcbn1cblxuLyoqXG4gKiBUaGUgZGVwZW5kZW5jaWVzIG9mIHRoZSByZWFjdGlvbiB0aGF0IGlzIGN1cnJlbnRseSBiZWluZyBleGVjdXRlZC4gSW4gbWFueSBjYXNlcyxcbiAqIHRoZSBkZXBlbmRlbmNpZXMgYXJlIHVuY2hhbmdlZCBiZXR3ZWVuIHJ1bnMsIGFuZCBzbyB0aGlzIHdpbGwgYmUgYG51bGxgIHVubGVzc1xuICogYW5kIHVudGlsIGEgbmV3IGRlcGVuZGVuY3kgaXMgYWNjZXNzZWQgXHUyMDE0IHdlIHRyYWNrIHRoaXMgdmlhIGBza2lwcGVkX2RlcHNgXG4gKiBAdHlwZSB7bnVsbCB8IFZhbHVlW119XG4gKi9cbmV4cG9ydCBsZXQgbmV3X2RlcHMgPSBudWxsO1xuXG5sZXQgc2tpcHBlZF9kZXBzID0gMDtcblxuLyoqXG4gKiBUcmFja3Mgd3JpdGVzIHRoYXQgdGhlIGVmZmVjdCBpdCdzIGV4ZWN1dGVkIGluIGRvZXNuJ3QgbGlzdGVuIHRvIHlldCxcbiAqIHNvIHRoYXQgdGhlIGRlcGVuZGVuY3kgY2FuIGJlIGFkZGVkIHRvIHRoZSBlZmZlY3QgbGF0ZXIgb24gaWYgaXQgdGhlbiByZWFkcyBpdFxuICogQHR5cGUge251bGwgfCBTb3VyY2VbXX1cbiAqL1xuZXhwb3J0IGxldCB1bnRyYWNrZWRfd3JpdGVzID0gbnVsbDtcblxuLyoqIEBwYXJhbSB7bnVsbCB8IFNvdXJjZVtdfSB2YWx1ZSAqL1xuZXhwb3J0IGZ1bmN0aW9uIHNldF91bnRyYWNrZWRfd3JpdGVzKHZhbHVlKSB7XG5cdHVudHJhY2tlZF93cml0ZXMgPSB2YWx1ZTtcbn1cblxuLyoqXG4gKiBAdHlwZSB7bnVtYmVyfSBVc2VkIGJ5IHNvdXJjZXMgYW5kIGRlcml2ZWRzIGZvciBoYW5kbGluZyB1cGRhdGVzLlxuICogVmVyc2lvbiBzdGFydHMgZnJvbSAxIHNvIHRoYXQgdW5vd25lZCBkZXJpdmVkcyBkaWZmZXJlbnRpYXRlIGJldHdlZW4gYSBjcmVhdGVkIGVmZmVjdCBhbmQgYSBydW4gb25lIGZvciB0cmFjaW5nXG4gKiovXG5sZXQgd3JpdGVfdmVyc2lvbiA9IDE7XG5cbi8qKiBAdHlwZSB7bnVtYmVyfSBVc2VkIHRvIHZlcnNpb24gZWFjaCByZWFkIG9mIGEgc291cmNlIG9mIGRlcml2ZWQgdG8gYXZvaWQgZHVwbGljYXRpbmcgZGVwZWRlbmNpZXMgaW5zaWRlIGEgcmVhY3Rpb24gKi9cbmxldCByZWFkX3ZlcnNpb24gPSAwO1xuXG4vLyBJZiB3ZSBhcmUgd29ya2luZyB3aXRoIGEgZ2V0KCkgY2hhaW4gdGhhdCBoYXMgbm8gYWN0aXZlIGNvbnRhaW5lcixcbi8vIHRvIHByZXZlbnQgbWVtb3J5IGxlYWtzLCB3ZSBza2lwIGFkZGluZyB0aGUgcmVhY3Rpb24uXG5leHBvcnQgbGV0IHNraXBfcmVhY3Rpb24gPSBmYWxzZTtcbi8vIEhhbmRsZSBjb2xsZWN0aW5nIGFsbCBzaWduYWxzIHdoaWNoIGFyZSByZWFkIGR1cmluZyBhIHNwZWNpZmljIHRpbWUgZnJhbWVcbi8qKiBAdHlwZSB7U2V0PFZhbHVlPiB8IG51bGx9ICovXG5leHBvcnQgbGV0IGNhcHR1cmVkX3NpZ25hbHMgPSBudWxsO1xuXG4vKiogQHBhcmFtIHtTZXQ8VmFsdWU+IHwgbnVsbH0gdmFsdWUgKi9cbmV4cG9ydCBmdW5jdGlvbiBzZXRfY2FwdHVyZWRfc2lnbmFscyh2YWx1ZSkge1xuXHRjYXB0dXJlZF9zaWduYWxzID0gdmFsdWU7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBpbmNyZW1lbnRfd3JpdGVfdmVyc2lvbigpIHtcblx0cmV0dXJuICsrd3JpdGVfdmVyc2lvbjtcbn1cblxuLyoqXG4gKiBEZXRlcm1pbmVzIHdoZXRoZXIgYSBkZXJpdmVkIG9yIGVmZmVjdCBpcyBkaXJ0eS5cbiAqIElmIGl0IGlzIE1BWUJFX0RJUlRZLCB3aWxsIHNldCB0aGUgc3RhdHVzIHRvIENMRUFOXG4gKiBAcGFyYW0ge1JlYWN0aW9ufSByZWFjdGlvblxuICogQHJldHVybnMge2Jvb2xlYW59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjaGVja19kaXJ0aW5lc3MocmVhY3Rpb24pIHtcblx0dmFyIGZsYWdzID0gcmVhY3Rpb24uZjtcblxuXHRpZiAoKGZsYWdzICYgRElSVFkpICE9PSAwKSB7XG5cdFx0cmV0dXJuIHRydWU7XG5cdH1cblxuXHRpZiAoKGZsYWdzICYgTUFZQkVfRElSVFkpICE9PSAwKSB7XG5cdFx0dmFyIGRlcGVuZGVuY2llcyA9IHJlYWN0aW9uLmRlcHM7XG5cdFx0dmFyIGlzX3Vub3duZWQgPSAoZmxhZ3MgJiBVTk9XTkVEKSAhPT0gMDtcblxuXHRcdGlmIChkZXBlbmRlbmNpZXMgIT09IG51bGwpIHtcblx0XHRcdHZhciBpO1xuXHRcdFx0dmFyIGRlcGVuZGVuY3k7XG5cdFx0XHR2YXIgaXNfZGlzY29ubmVjdGVkID0gKGZsYWdzICYgRElTQ09OTkVDVEVEKSAhPT0gMDtcblx0XHRcdHZhciBpc191bm93bmVkX2Nvbm5lY3RlZCA9IGlzX3Vub3duZWQgJiYgYWN0aXZlX2VmZmVjdCAhPT0gbnVsbCAmJiAhc2tpcF9yZWFjdGlvbjtcblx0XHRcdHZhciBsZW5ndGggPSBkZXBlbmRlbmNpZXMubGVuZ3RoO1xuXG5cdFx0XHQvLyBJZiB3ZSBhcmUgd29ya2luZyB3aXRoIGEgZGlzY29ubmVjdGVkIG9yIGFuIHVub3duZWQgc2lnbmFsIHRoYXQgaXMgbm93IGNvbm5lY3RlZCAoZHVlIHRvIGFuIGFjdGl2ZSBlZmZlY3QpXG5cdFx0XHQvLyB0aGVuIHdlIG5lZWQgdG8gcmUtY29ubmVjdCB0aGUgcmVhY3Rpb24gdG8gdGhlIGRlcGVuZGVuY3lcblx0XHRcdGlmIChpc19kaXNjb25uZWN0ZWQgfHwgaXNfdW5vd25lZF9jb25uZWN0ZWQpIHtcblx0XHRcdFx0dmFyIGRlcml2ZWQgPSAvKiogQHR5cGUge0Rlcml2ZWR9ICovIChyZWFjdGlvbik7XG5cdFx0XHRcdHZhciBwYXJlbnQgPSBkZXJpdmVkLnBhcmVudDtcblxuXHRcdFx0XHRmb3IgKGkgPSAwOyBpIDwgbGVuZ3RoOyBpKyspIHtcblx0XHRcdFx0XHRkZXBlbmRlbmN5ID0gZGVwZW5kZW5jaWVzW2ldO1xuXG5cdFx0XHRcdFx0Ly8gV2UgYWx3YXlzIHJlLWFkZCBhbGwgcmVhY3Rpb25zIChldmVuIGR1cGxpY2F0ZXMpIGlmIHRoZSBkZXJpdmVkIHdhc1xuXHRcdFx0XHRcdC8vIHByZXZpb3VzbHkgZGlzY29ubmVjdGVkLCBob3dldmVyIHdlIGRvbid0IGlmIGl0IHdhcyB1bm93bmVkIGFzIHdlXG5cdFx0XHRcdFx0Ly8gZGUtZHVwbGljYXRlIGRlcGVuZGVuY2llcyBpbiB0aGF0IGNhc2Vcblx0XHRcdFx0XHRpZiAoaXNfZGlzY29ubmVjdGVkIHx8ICFkZXBlbmRlbmN5Py5yZWFjdGlvbnM/LmluY2x1ZGVzKGRlcml2ZWQpKSB7XG5cdFx0XHRcdFx0XHQoZGVwZW5kZW5jeS5yZWFjdGlvbnMgPz89IFtdKS5wdXNoKGRlcml2ZWQpO1xuXHRcdFx0XHRcdH1cblx0XHRcdFx0fVxuXG5cdFx0XHRcdGlmIChpc19kaXNjb25uZWN0ZWQpIHtcblx0XHRcdFx0XHRkZXJpdmVkLmYgXj0gRElTQ09OTkVDVEVEO1xuXHRcdFx0XHR9XG5cdFx0XHRcdC8vIElmIHRoZSB1bm93bmVkIGRlcml2ZWQgaXMgbm93IGZ1bGx5IGNvbm5lY3RlZCB0byB0aGUgZ3JhcGggYWdhaW4gKGl0J3MgdW5vd25lZCBhbmQgcmVjb25uZWN0ZWQsIGhhcyBhIHBhcmVudFxuXHRcdFx0XHQvLyBhbmQgdGhlIHBhcmVudCBpcyBub3QgdW5vd25lZCksIHRoZW4gd2UgY2FuIG1hcmsgaXQgYXMgY29ubmVjdGVkIGFnYWluLCByZW1vdmluZyB0aGUgbmVlZCBmb3IgdGhlIHVub3duZWRcblx0XHRcdFx0Ly8gZmxhZ1xuXHRcdFx0XHRpZiAoaXNfdW5vd25lZF9jb25uZWN0ZWQgJiYgcGFyZW50ICE9PSBudWxsICYmIChwYXJlbnQuZiAmIFVOT1dORUQpID09PSAwKSB7XG5cdFx0XHRcdFx0ZGVyaXZlZC5mIF49IFVOT1dORUQ7XG5cdFx0XHRcdH1cblx0XHRcdH1cblxuXHRcdFx0Zm9yIChpID0gMDsgaSA8IGxlbmd0aDsgaSsrKSB7XG5cdFx0XHRcdGRlcGVuZGVuY3kgPSBkZXBlbmRlbmNpZXNbaV07XG5cblx0XHRcdFx0aWYgKGNoZWNrX2RpcnRpbmVzcygvKiogQHR5cGUge0Rlcml2ZWR9ICovIChkZXBlbmRlbmN5KSkpIHtcblx0XHRcdFx0XHR1cGRhdGVfZGVyaXZlZCgvKiogQHR5cGUge0Rlcml2ZWR9ICovIChkZXBlbmRlbmN5KSk7XG5cdFx0XHRcdH1cblxuXHRcdFx0XHRpZiAoZGVwZW5kZW5jeS53diA+IHJlYWN0aW9uLnd2KSB7XG5cdFx0XHRcdFx0cmV0dXJuIHRydWU7XG5cdFx0XHRcdH1cblx0XHRcdH1cblx0XHR9XG5cblx0XHQvLyBVbm93bmVkIHNpZ25hbHMgc2hvdWxkIG5ldmVyIGJlIG1hcmtlZCBhcyBjbGVhbiB1bmxlc3MgdGhleVxuXHRcdC8vIGFyZSB1c2VkIHdpdGhpbiBhbiBhY3RpdmVfZWZmZWN0IHdpdGhvdXQgc2tpcF9yZWFjdGlvblxuXHRcdGlmICghaXNfdW5vd25lZCB8fCAoYWN0aXZlX2VmZmVjdCAhPT0gbnVsbCAmJiAhc2tpcF9yZWFjdGlvbikpIHtcblx0XHRcdHNldF9zaWduYWxfc3RhdHVzKHJlYWN0aW9uLCBDTEVBTik7XG5cdFx0fVxuXHR9XG5cblx0cmV0dXJuIGZhbHNlO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7dW5rbm93bn0gZXJyb3JcbiAqIEBwYXJhbSB7RWZmZWN0fSBlZmZlY3RcbiAqL1xuZnVuY3Rpb24gcHJvcGFnYXRlX2Vycm9yKGVycm9yLCBlZmZlY3QpIHtcblx0LyoqIEB0eXBlIHtFZmZlY3QgfCBudWxsfSAqL1xuXHR2YXIgY3VycmVudCA9IGVmZmVjdDtcblxuXHR3aGlsZSAoY3VycmVudCAhPT0gbnVsbCkge1xuXHRcdGlmICgoY3VycmVudC5mICYgQk9VTkRBUllfRUZGRUNUKSAhPT0gMCkge1xuXHRcdFx0dHJ5IHtcblx0XHRcdFx0Ly8gQHRzLWV4cGVjdC1lcnJvclxuXHRcdFx0XHRjdXJyZW50LmZuKGVycm9yKTtcblx0XHRcdFx0cmV0dXJuO1xuXHRcdFx0fSBjYXRjaCB7XG5cdFx0XHRcdC8vIFJlbW92ZSBib3VuZGFyeSBmbGFnIGZyb20gZWZmZWN0XG5cdFx0XHRcdGN1cnJlbnQuZiBePSBCT1VOREFSWV9FRkZFQ1Q7XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0Y3VycmVudCA9IGN1cnJlbnQucGFyZW50O1xuXHR9XG5cblx0aXNfdGhyb3dpbmdfZXJyb3IgPSBmYWxzZTtcblx0dGhyb3cgZXJyb3I7XG59XG5cbi8qKlxuICogQHBhcmFtIHtFZmZlY3R9IGVmZmVjdFxuICovXG5mdW5jdGlvbiBzaG91bGRfcmV0aHJvd19lcnJvcihlZmZlY3QpIHtcblx0cmV0dXJuIChcblx0XHQoZWZmZWN0LmYgJiBERVNUUk9ZRUQpID09PSAwICYmXG5cdFx0KGVmZmVjdC5wYXJlbnQgPT09IG51bGwgfHwgKGVmZmVjdC5wYXJlbnQuZiAmIEJPVU5EQVJZX0VGRkVDVCkgPT09IDApXG5cdCk7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiByZXNldF9pc190aHJvd2luZ19lcnJvcigpIHtcblx0aXNfdGhyb3dpbmdfZXJyb3IgPSBmYWxzZTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge3Vua25vd259IGVycm9yXG4gKiBAcGFyYW0ge0VmZmVjdH0gZWZmZWN0XG4gKiBAcGFyYW0ge0VmZmVjdCB8IG51bGx9IHByZXZpb3VzX2VmZmVjdFxuICogQHBhcmFtIHtDb21wb25lbnRDb250ZXh0IHwgbnVsbH0gY29tcG9uZW50X2NvbnRleHRcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGhhbmRsZV9lcnJvcihlcnJvciwgZWZmZWN0LCBwcmV2aW91c19lZmZlY3QsIGNvbXBvbmVudF9jb250ZXh0KSB7XG5cdGlmIChpc190aHJvd2luZ19lcnJvcikge1xuXHRcdGlmIChwcmV2aW91c19lZmZlY3QgPT09IG51bGwpIHtcblx0XHRcdGlzX3Rocm93aW5nX2Vycm9yID0gZmFsc2U7XG5cdFx0fVxuXG5cdFx0aWYgKHNob3VsZF9yZXRocm93X2Vycm9yKGVmZmVjdCkpIHtcblx0XHRcdHRocm93IGVycm9yO1xuXHRcdH1cblxuXHRcdHJldHVybjtcblx0fVxuXG5cdGlmIChwcmV2aW91c19lZmZlY3QgIT09IG51bGwpIHtcblx0XHRpc190aHJvd2luZ19lcnJvciA9IHRydWU7XG5cdH1cblxuXHRpZiAoXG5cdFx0IURFViB8fFxuXHRcdGNvbXBvbmVudF9jb250ZXh0ID09PSBudWxsIHx8XG5cdFx0IShlcnJvciBpbnN0YW5jZW9mIEVycm9yKSB8fFxuXHRcdGhhbmRsZWRfZXJyb3JzLmhhcyhlcnJvcilcblx0KSB7XG5cdFx0cHJvcGFnYXRlX2Vycm9yKGVycm9yLCBlZmZlY3QpO1xuXHRcdHJldHVybjtcblx0fVxuXG5cdGhhbmRsZWRfZXJyb3JzLmFkZChlcnJvcik7XG5cblx0Y29uc3QgY29tcG9uZW50X3N0YWNrID0gW107XG5cblx0Y29uc3QgZWZmZWN0X25hbWUgPSBlZmZlY3QuZm4/Lm5hbWU7XG5cblx0aWYgKGVmZmVjdF9uYW1lKSB7XG5cdFx0Y29tcG9uZW50X3N0YWNrLnB1c2goZWZmZWN0X25hbWUpO1xuXHR9XG5cblx0LyoqIEB0eXBlIHtDb21wb25lbnRDb250ZXh0IHwgbnVsbH0gKi9cblx0bGV0IGN1cnJlbnRfY29udGV4dCA9IGNvbXBvbmVudF9jb250ZXh0O1xuXG5cdHdoaWxlIChjdXJyZW50X2NvbnRleHQgIT09IG51bGwpIHtcblx0XHRpZiAoREVWKSB7XG5cdFx0XHQvKiogQHR5cGUge3N0cmluZ30gKi9cblx0XHRcdHZhciBmaWxlbmFtZSA9IGN1cnJlbnRfY29udGV4dC5mdW5jdGlvbj8uW0ZJTEVOQU1FXTtcblxuXHRcdFx0aWYgKGZpbGVuYW1lKSB7XG5cdFx0XHRcdGNvbnN0IGZpbGUgPSBmaWxlbmFtZS5zcGxpdCgnLycpLnBvcCgpO1xuXHRcdFx0XHRjb21wb25lbnRfc3RhY2sucHVzaChmaWxlKTtcblx0XHRcdH1cblx0XHR9XG5cblx0XHRjdXJyZW50X2NvbnRleHQgPSBjdXJyZW50X2NvbnRleHQucDtcblx0fVxuXG5cdGNvbnN0IGluZGVudCA9IGlzX2ZpcmVmb3ggPyAnICAnIDogJ1xcdCc7XG5cdGRlZmluZV9wcm9wZXJ0eShlcnJvciwgJ21lc3NhZ2UnLCB7XG5cdFx0dmFsdWU6IGVycm9yLm1lc3NhZ2UgKyBgXFxuJHtjb21wb25lbnRfc3RhY2subWFwKChuYW1lKSA9PiBgXFxuJHtpbmRlbnR9aW4gJHtuYW1lfWApLmpvaW4oJycpfVxcbmBcblx0fSk7XG5cdGRlZmluZV9wcm9wZXJ0eShlcnJvciwgJ2NvbXBvbmVudF9zdGFjaycsIHtcblx0XHR2YWx1ZTogY29tcG9uZW50X3N0YWNrXG5cdH0pO1xuXG5cdGNvbnN0IHN0YWNrID0gZXJyb3Iuc3RhY2s7XG5cblx0Ly8gRmlsdGVyIG91dCBpbnRlcm5hbCBmaWxlcyBmcm9tIGNhbGxzdGFja1xuXHRpZiAoc3RhY2spIHtcblx0XHRjb25zdCBsaW5lcyA9IHN0YWNrLnNwbGl0KCdcXG4nKTtcblx0XHRjb25zdCBuZXdfbGluZXMgPSBbXTtcblx0XHRmb3IgKGxldCBpID0gMDsgaSA8IGxpbmVzLmxlbmd0aDsgaSsrKSB7XG5cdFx0XHRjb25zdCBsaW5lID0gbGluZXNbaV07XG5cdFx0XHRpZiAobGluZS5pbmNsdWRlcygnc3ZlbHRlL3NyYy9pbnRlcm5hbCcpKSB7XG5cdFx0XHRcdGNvbnRpbnVlO1xuXHRcdFx0fVxuXHRcdFx0bmV3X2xpbmVzLnB1c2gobGluZSk7XG5cdFx0fVxuXHRcdGRlZmluZV9wcm9wZXJ0eShlcnJvciwgJ3N0YWNrJywge1xuXHRcdFx0dmFsdWU6IG5ld19saW5lcy5qb2luKCdcXG4nKVxuXHRcdH0pO1xuXHR9XG5cblx0cHJvcGFnYXRlX2Vycm9yKGVycm9yLCBlZmZlY3QpO1xuXG5cdGlmIChzaG91bGRfcmV0aHJvd19lcnJvcihlZmZlY3QpKSB7XG5cdFx0dGhyb3cgZXJyb3I7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge1ZhbHVlfSBzaWduYWxcbiAqIEBwYXJhbSB7RWZmZWN0fSBlZmZlY3RcbiAqIEBwYXJhbSB7Ym9vbGVhbn0gW3Jvb3RdXG4gKi9cbmZ1bmN0aW9uIHNjaGVkdWxlX3Bvc3NpYmxlX2VmZmVjdF9zZWxmX2ludmFsaWRhdGlvbihzaWduYWwsIGVmZmVjdCwgcm9vdCA9IHRydWUpIHtcblx0dmFyIHJlYWN0aW9ucyA9IHNpZ25hbC5yZWFjdGlvbnM7XG5cdGlmIChyZWFjdGlvbnMgPT09IG51bGwpIHJldHVybjtcblxuXHRmb3IgKHZhciBpID0gMDsgaSA8IHJlYWN0aW9ucy5sZW5ndGg7IGkrKykge1xuXHRcdHZhciByZWFjdGlvbiA9IHJlYWN0aW9uc1tpXTtcblx0XHRpZiAoKHJlYWN0aW9uLmYgJiBERVJJVkVEKSAhPT0gMCkge1xuXHRcdFx0c2NoZWR1bGVfcG9zc2libGVfZWZmZWN0X3NlbGZfaW52YWxpZGF0aW9uKC8qKiBAdHlwZSB7RGVyaXZlZH0gKi8gKHJlYWN0aW9uKSwgZWZmZWN0LCBmYWxzZSk7XG5cdFx0fSBlbHNlIGlmIChlZmZlY3QgPT09IHJlYWN0aW9uKSB7XG5cdFx0XHRpZiAocm9vdCkge1xuXHRcdFx0XHRzZXRfc2lnbmFsX3N0YXR1cyhyZWFjdGlvbiwgRElSVFkpO1xuXHRcdFx0fSBlbHNlIGlmICgocmVhY3Rpb24uZiAmIENMRUFOKSAhPT0gMCkge1xuXHRcdFx0XHRzZXRfc2lnbmFsX3N0YXR1cyhyZWFjdGlvbiwgTUFZQkVfRElSVFkpO1xuXHRcdFx0fVxuXHRcdFx0c2NoZWR1bGVfZWZmZWN0KC8qKiBAdHlwZSB7RWZmZWN0fSAqLyAocmVhY3Rpb24pKTtcblx0XHR9XG5cdH1cbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUgVlxuICogQHBhcmFtIHtSZWFjdGlvbn0gcmVhY3Rpb25cbiAqIEByZXR1cm5zIHtWfVxuICovXG5leHBvcnQgZnVuY3Rpb24gdXBkYXRlX3JlYWN0aW9uKHJlYWN0aW9uKSB7XG5cdHZhciBwcmV2aW91c19kZXBzID0gbmV3X2RlcHM7XG5cdHZhciBwcmV2aW91c19za2lwcGVkX2RlcHMgPSBza2lwcGVkX2RlcHM7XG5cdHZhciBwcmV2aW91c191bnRyYWNrZWRfd3JpdGVzID0gdW50cmFja2VkX3dyaXRlcztcblx0dmFyIHByZXZpb3VzX3JlYWN0aW9uID0gYWN0aXZlX3JlYWN0aW9uO1xuXHR2YXIgcHJldmlvdXNfc2tpcF9yZWFjdGlvbiA9IHNraXBfcmVhY3Rpb247XG5cdHZhciBwcmV2X2Rlcml2ZWRfc291cmNlcyA9IGRlcml2ZWRfc291cmNlcztcblx0dmFyIHByZXZpb3VzX2NvbXBvbmVudF9jb250ZXh0ID0gY29tcG9uZW50X2NvbnRleHQ7XG5cdHZhciBwcmV2aW91c191bnRyYWNraW5nID0gdW50cmFja2luZztcblx0dmFyIGZsYWdzID0gcmVhY3Rpb24uZjtcblxuXHRuZXdfZGVwcyA9IC8qKiBAdHlwZSB7bnVsbCB8IFZhbHVlW119ICovIChudWxsKTtcblx0c2tpcHBlZF9kZXBzID0gMDtcblx0dW50cmFja2VkX3dyaXRlcyA9IG51bGw7XG5cdGFjdGl2ZV9yZWFjdGlvbiA9IChmbGFncyAmIChCUkFOQ0hfRUZGRUNUIHwgUk9PVF9FRkZFQ1QpKSA9PT0gMCA/IHJlYWN0aW9uIDogbnVsbDtcblx0c2tpcF9yZWFjdGlvbiA9XG5cdFx0KGZsYWdzICYgVU5PV05FRCkgIT09IDAgJiZcblx0XHQoIWlzX2ZsdXNoaW5nX2VmZmVjdCB8fCBwcmV2aW91c19yZWFjdGlvbiA9PT0gbnVsbCB8fCBwcmV2aW91c191bnRyYWNraW5nKTtcblxuXHRkZXJpdmVkX3NvdXJjZXMgPSBudWxsO1xuXHRzZXRfY29tcG9uZW50X2NvbnRleHQocmVhY3Rpb24uY3R4KTtcblx0dW50cmFja2luZyA9IGZhbHNlO1xuXHRyZWFkX3ZlcnNpb24rKztcblxuXHR0cnkge1xuXHRcdHZhciByZXN1bHQgPSAvKiogQHR5cGUge0Z1bmN0aW9ufSAqLyAoMCwgcmVhY3Rpb24uZm4pKCk7XG5cdFx0dmFyIGRlcHMgPSByZWFjdGlvbi5kZXBzO1xuXG5cdFx0aWYgKG5ld19kZXBzICE9PSBudWxsKSB7XG5cdFx0XHR2YXIgaTtcblxuXHRcdFx0cmVtb3ZlX3JlYWN0aW9ucyhyZWFjdGlvbiwgc2tpcHBlZF9kZXBzKTtcblxuXHRcdFx0aWYgKGRlcHMgIT09IG51bGwgJiYgc2tpcHBlZF9kZXBzID4gMCkge1xuXHRcdFx0XHRkZXBzLmxlbmd0aCA9IHNraXBwZWRfZGVwcyArIG5ld19kZXBzLmxlbmd0aDtcblx0XHRcdFx0Zm9yIChpID0gMDsgaSA8IG5ld19kZXBzLmxlbmd0aDsgaSsrKSB7XG5cdFx0XHRcdFx0ZGVwc1tza2lwcGVkX2RlcHMgKyBpXSA9IG5ld19kZXBzW2ldO1xuXHRcdFx0XHR9XG5cdFx0XHR9IGVsc2Uge1xuXHRcdFx0XHRyZWFjdGlvbi5kZXBzID0gZGVwcyA9IG5ld19kZXBzO1xuXHRcdFx0fVxuXG5cdFx0XHRpZiAoIXNraXBfcmVhY3Rpb24pIHtcblx0XHRcdFx0Zm9yIChpID0gc2tpcHBlZF9kZXBzOyBpIDwgZGVwcy5sZW5ndGg7IGkrKykge1xuXHRcdFx0XHRcdChkZXBzW2ldLnJlYWN0aW9ucyA/Pz0gW10pLnB1c2gocmVhY3Rpb24pO1xuXHRcdFx0XHR9XG5cdFx0XHR9XG5cdFx0fSBlbHNlIGlmIChkZXBzICE9PSBudWxsICYmIHNraXBwZWRfZGVwcyA8IGRlcHMubGVuZ3RoKSB7XG5cdFx0XHRyZW1vdmVfcmVhY3Rpb25zKHJlYWN0aW9uLCBza2lwcGVkX2RlcHMpO1xuXHRcdFx0ZGVwcy5sZW5ndGggPSBza2lwcGVkX2RlcHM7XG5cdFx0fVxuXG5cdFx0Ly8gSWYgd2UncmUgaW5zaWRlIGFuIGVmZmVjdCBhbmQgd2UgaGF2ZSB1bnRyYWNrZWQgd3JpdGVzLCB0aGVuIHdlIG5lZWQgdG9cblx0XHQvLyBlbnN1cmUgdGhhdCBpZiBhbnkgb2YgdGhvc2UgdW50cmFja2VkIHdyaXRlcyByZXN1bHQgaW4gcmUtaW52YWxpZGF0aW9uXG5cdFx0Ly8gb2YgdGhlIGN1cnJlbnQgZWZmZWN0LCB0aGVuIHRoYXQgaGFwcGVucyBhY2NvcmRpbmdseVxuXHRcdGlmIChcblx0XHRcdGlzX3J1bmVzKCkgJiZcblx0XHRcdHVudHJhY2tlZF93cml0ZXMgIT09IG51bGwgJiZcblx0XHRcdCF1bnRyYWNraW5nICYmXG5cdFx0XHRkZXBzICE9PSBudWxsICYmXG5cdFx0XHQocmVhY3Rpb24uZiAmIChERVJJVkVEIHwgTUFZQkVfRElSVFkgfCBESVJUWSkpID09PSAwXG5cdFx0KSB7XG5cdFx0XHRmb3IgKGkgPSAwOyBpIDwgLyoqIEB0eXBlIHtTb3VyY2VbXX0gKi8gKHVudHJhY2tlZF93cml0ZXMpLmxlbmd0aDsgaSsrKSB7XG5cdFx0XHRcdHNjaGVkdWxlX3Bvc3NpYmxlX2VmZmVjdF9zZWxmX2ludmFsaWRhdGlvbihcblx0XHRcdFx0XHR1bnRyYWNrZWRfd3JpdGVzW2ldLFxuXHRcdFx0XHRcdC8qKiBAdHlwZSB7RWZmZWN0fSAqLyAocmVhY3Rpb24pXG5cdFx0XHRcdCk7XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0Ly8gSWYgd2UgYXJlIHJldHVybmluZyB0byBhbiBwcmV2aW91cyByZWFjdGlvbiB0aGVuXG5cdFx0Ly8gd2UgbmVlZCB0byBpbmNyZW1lbnQgdGhlIHJlYWQgdmVyc2lvbiB0byBlbnN1cmUgdGhhdFxuXHRcdC8vIGFueSBkZXBlbmRlbmNpZXMgaW4gdGhpcyByZWFjdGlvbiBhcmVuJ3QgbWFya2VkIHdpdGhcblx0XHQvLyB0aGUgc2FtZSB2ZXJzaW9uXG5cdFx0aWYgKHByZXZpb3VzX3JlYWN0aW9uICE9PSBudWxsKSB7XG5cdFx0XHRyZWFkX3ZlcnNpb24rKztcblx0XHR9XG5cblx0XHRyZXR1cm4gcmVzdWx0O1xuXHR9IGZpbmFsbHkge1xuXHRcdG5ld19kZXBzID0gcHJldmlvdXNfZGVwcztcblx0XHRza2lwcGVkX2RlcHMgPSBwcmV2aW91c19za2lwcGVkX2RlcHM7XG5cdFx0dW50cmFja2VkX3dyaXRlcyA9IHByZXZpb3VzX3VudHJhY2tlZF93cml0ZXM7XG5cdFx0YWN0aXZlX3JlYWN0aW9uID0gcHJldmlvdXNfcmVhY3Rpb247XG5cdFx0c2tpcF9yZWFjdGlvbiA9IHByZXZpb3VzX3NraXBfcmVhY3Rpb247XG5cdFx0ZGVyaXZlZF9zb3VyY2VzID0gcHJldl9kZXJpdmVkX3NvdXJjZXM7XG5cdFx0c2V0X2NvbXBvbmVudF9jb250ZXh0KHByZXZpb3VzX2NvbXBvbmVudF9jb250ZXh0KTtcblx0XHR1bnRyYWNraW5nID0gcHJldmlvdXNfdW50cmFja2luZztcblx0fVxufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0ge1JlYWN0aW9ufSBzaWduYWxcbiAqIEBwYXJhbSB7VmFsdWU8Vj59IGRlcGVuZGVuY3lcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5mdW5jdGlvbiByZW1vdmVfcmVhY3Rpb24oc2lnbmFsLCBkZXBlbmRlbmN5KSB7XG5cdGxldCByZWFjdGlvbnMgPSBkZXBlbmRlbmN5LnJlYWN0aW9ucztcblx0aWYgKHJlYWN0aW9ucyAhPT0gbnVsbCkge1xuXHRcdHZhciBpbmRleCA9IGluZGV4X29mLmNhbGwocmVhY3Rpb25zLCBzaWduYWwpO1xuXHRcdGlmIChpbmRleCAhPT0gLTEpIHtcblx0XHRcdHZhciBuZXdfbGVuZ3RoID0gcmVhY3Rpb25zLmxlbmd0aCAtIDE7XG5cdFx0XHRpZiAobmV3X2xlbmd0aCA9PT0gMCkge1xuXHRcdFx0XHRyZWFjdGlvbnMgPSBkZXBlbmRlbmN5LnJlYWN0aW9ucyA9IG51bGw7XG5cdFx0XHR9IGVsc2Uge1xuXHRcdFx0XHQvLyBTd2FwIHdpdGggbGFzdCBlbGVtZW50IGFuZCB0aGVuIHJlbW92ZS5cblx0XHRcdFx0cmVhY3Rpb25zW2luZGV4XSA9IHJlYWN0aW9uc1tuZXdfbGVuZ3RoXTtcblx0XHRcdFx0cmVhY3Rpb25zLnBvcCgpO1xuXHRcdFx0fVxuXHRcdH1cblx0fVxuXHQvLyBJZiB0aGUgZGVyaXZlZCBoYXMgbm8gcmVhY3Rpb25zLCB0aGVuIHdlIGNhbiBkaXNjb25uZWN0IGl0IGZyb20gdGhlIGdyYXBoLFxuXHQvLyBhbGxvd2luZyBpdCB0byBlaXRoZXIgcmVjb25uZWN0IGluIHRoZSBmdXR1cmUsIG9yIGJlIEdDJ2QgYnkgdGhlIFZNLlxuXHRpZiAoXG5cdFx0cmVhY3Rpb25zID09PSBudWxsICYmXG5cdFx0KGRlcGVuZGVuY3kuZiAmIERFUklWRUQpICE9PSAwICYmXG5cdFx0Ly8gRGVzdHJveWluZyBhIGNoaWxkIGVmZmVjdCB3aGlsZSB1cGRhdGluZyBhIHBhcmVudCBlZmZlY3QgY2FuIGNhdXNlIGEgZGVwZW5kZW5jeSB0byBhcHBlYXJcblx0XHQvLyB0byBiZSB1bnVzZWQsIHdoZW4gaW4gZmFjdCBpdCBpcyB1c2VkIGJ5IHRoZSBjdXJyZW50bHktdXBkYXRpbmcgcGFyZW50LiBDaGVja2luZyBgbmV3X2RlcHNgXG5cdFx0Ly8gYWxsb3dzIHVzIHRvIHNraXAgdGhlIGV4cGVuc2l2ZSB3b3JrIG9mIGRpc2Nvbm5lY3RpbmcgYW5kIGltbWVkaWF0ZWx5IHJlY29ubmVjdGluZyBpdFxuXHRcdChuZXdfZGVwcyA9PT0gbnVsbCB8fCAhbmV3X2RlcHMuaW5jbHVkZXMoZGVwZW5kZW5jeSkpXG5cdCkge1xuXHRcdHNldF9zaWduYWxfc3RhdHVzKGRlcGVuZGVuY3ksIE1BWUJFX0RJUlRZKTtcblx0XHQvLyBJZiB3ZSBhcmUgd29ya2luZyB3aXRoIGEgZGVyaXZlZCB0aGF0IGlzIG93bmVkIGJ5IGFuIGVmZmVjdCwgdGhlbiBtYXJrIGl0IGFzIGJlaW5nXG5cdFx0Ly8gZGlzY29ubmVjdGVkLlxuXHRcdGlmICgoZGVwZW5kZW5jeS5mICYgKFVOT1dORUQgfCBESVNDT05ORUNURUQpKSA9PT0gMCkge1xuXHRcdFx0ZGVwZW5kZW5jeS5mIF49IERJU0NPTk5FQ1RFRDtcblx0XHR9XG5cdFx0Ly8gRGlzY29ubmVjdCBhbnkgcmVhY3Rpb25zIG93bmVkIGJ5IHRoaXMgcmVhY3Rpb25cblx0XHRkZXN0cm95X2Rlcml2ZWRfZWZmZWN0cygvKiogQHR5cGUge0Rlcml2ZWR9ICoqLyAoZGVwZW5kZW5jeSkpO1xuXHRcdHJlbW92ZV9yZWFjdGlvbnMoLyoqIEB0eXBlIHtEZXJpdmVkfSAqKi8gKGRlcGVuZGVuY3kpLCAwKTtcblx0fVxufVxuXG4vKipcbiAqIEBwYXJhbSB7UmVhY3Rpb259IHNpZ25hbFxuICogQHBhcmFtIHtudW1iZXJ9IHN0YXJ0X2luZGV4XG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHJlbW92ZV9yZWFjdGlvbnMoc2lnbmFsLCBzdGFydF9pbmRleCkge1xuXHR2YXIgZGVwZW5kZW5jaWVzID0gc2lnbmFsLmRlcHM7XG5cdGlmIChkZXBlbmRlbmNpZXMgPT09IG51bGwpIHJldHVybjtcblxuXHRmb3IgKHZhciBpID0gc3RhcnRfaW5kZXg7IGkgPCBkZXBlbmRlbmNpZXMubGVuZ3RoOyBpKyspIHtcblx0XHRyZW1vdmVfcmVhY3Rpb24oc2lnbmFsLCBkZXBlbmRlbmNpZXNbaV0pO1xuXHR9XG59XG5cbi8qKlxuICogQHBhcmFtIHtFZmZlY3R9IGVmZmVjdFxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiB1cGRhdGVfZWZmZWN0KGVmZmVjdCkge1xuXHR2YXIgZmxhZ3MgPSBlZmZlY3QuZjtcblxuXHRpZiAoKGZsYWdzICYgREVTVFJPWUVEKSAhPT0gMCkge1xuXHRcdHJldHVybjtcblx0fVxuXG5cdHNldF9zaWduYWxfc3RhdHVzKGVmZmVjdCwgQ0xFQU4pO1xuXG5cdHZhciBwcmV2aW91c19lZmZlY3QgPSBhY3RpdmVfZWZmZWN0O1xuXHR2YXIgcHJldmlvdXNfY29tcG9uZW50X2NvbnRleHQgPSBjb21wb25lbnRfY29udGV4dDtcblxuXHRhY3RpdmVfZWZmZWN0ID0gZWZmZWN0O1xuXG5cdGlmIChERVYpIHtcblx0XHR2YXIgcHJldmlvdXNfY29tcG9uZW50X2ZuID0gZGV2X2N1cnJlbnRfY29tcG9uZW50X2Z1bmN0aW9uO1xuXHRcdHNldF9kZXZfY3VycmVudF9jb21wb25lbnRfZnVuY3Rpb24oZWZmZWN0LmNvbXBvbmVudF9mdW5jdGlvbik7XG5cdH1cblxuXHR0cnkge1xuXHRcdGlmICgoZmxhZ3MgJiBCTE9DS19FRkZFQ1QpICE9PSAwKSB7XG5cdFx0XHRkZXN0cm95X2Jsb2NrX2VmZmVjdF9jaGlsZHJlbihlZmZlY3QpO1xuXHRcdH0gZWxzZSB7XG5cdFx0XHRkZXN0cm95X2VmZmVjdF9jaGlsZHJlbihlZmZlY3QpO1xuXHRcdH1cblxuXHRcdGV4ZWN1dGVfZWZmZWN0X3RlYXJkb3duKGVmZmVjdCk7XG5cdFx0dmFyIHRlYXJkb3duID0gdXBkYXRlX3JlYWN0aW9uKGVmZmVjdCk7XG5cdFx0ZWZmZWN0LnRlYXJkb3duID0gdHlwZW9mIHRlYXJkb3duID09PSAnZnVuY3Rpb24nID8gdGVhcmRvd24gOiBudWxsO1xuXHRcdGVmZmVjdC53diA9IHdyaXRlX3ZlcnNpb247XG5cblx0XHR2YXIgZGVwcyA9IGVmZmVjdC5kZXBzO1xuXG5cdFx0Ly8gSW4gREVWLCB3ZSBuZWVkIHRvIGhhbmRsZSBhIGNhc2Ugd2hlcmUgJGluc3BlY3QudHJhY2UoKSBtaWdodFxuXHRcdC8vIGluY29ycmVjdGx5IHN0YXRlIGEgc291cmNlIGRlcGVuZGVuY3kgaGFzIG5vdCBjaGFuZ2VkIHdoZW4gaXQgaGFzLlxuXHRcdC8vIFRoYXQncyBiZWFjdXNlIHRoYXQgc291cmNlIHdhcyBjaGFuZ2VkIGJ5IHRoZSBzYW1lIGVmZmVjdCwgY2F1c2luZ1xuXHRcdC8vIHRoZSB2ZXJzaW9ucyB0byBtYXRjaC4gV2UgY2FuIGF2b2lkIHRoaXMgYnkgaW5jcmVtZW50aW5nIHRoZSB2ZXJzaW9uXG5cdFx0aWYgKERFViAmJiB0cmFjaW5nX21vZGVfZmxhZyAmJiAoZWZmZWN0LmYgJiBESVJUWSkgIT09IDAgJiYgZGVwcyAhPT0gbnVsbCkge1xuXHRcdFx0Zm9yIChsZXQgaSA9IDA7IGkgPCBkZXBzLmxlbmd0aDsgaSsrKSB7XG5cdFx0XHRcdHZhciBkZXAgPSBkZXBzW2ldO1xuXHRcdFx0XHRpZiAoZGVwLnRyYWNlX25lZWRfaW5jcmVhc2UpIHtcblx0XHRcdFx0XHRkZXAud3YgPSBpbmNyZW1lbnRfd3JpdGVfdmVyc2lvbigpO1xuXHRcdFx0XHRcdGRlcC50cmFjZV9uZWVkX2luY3JlYXNlID0gdW5kZWZpbmVkO1xuXHRcdFx0XHRcdGRlcC50cmFjZV92ID0gdW5kZWZpbmVkO1xuXHRcdFx0XHR9XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0aWYgKERFVikge1xuXHRcdFx0ZGV2X2VmZmVjdF9zdGFjay5wdXNoKGVmZmVjdCk7XG5cdFx0fVxuXHR9IGNhdGNoIChlcnJvcikge1xuXHRcdGhhbmRsZV9lcnJvcihlcnJvciwgZWZmZWN0LCBwcmV2aW91c19lZmZlY3QsIHByZXZpb3VzX2NvbXBvbmVudF9jb250ZXh0IHx8IGVmZmVjdC5jdHgpO1xuXHR9IGZpbmFsbHkge1xuXHRcdGFjdGl2ZV9lZmZlY3QgPSBwcmV2aW91c19lZmZlY3Q7XG5cblx0XHRpZiAoREVWKSB7XG5cdFx0XHRzZXRfZGV2X2N1cnJlbnRfY29tcG9uZW50X2Z1bmN0aW9uKHByZXZpb3VzX2NvbXBvbmVudF9mbik7XG5cdFx0fVxuXHR9XG59XG5cbmZ1bmN0aW9uIGxvZ19lZmZlY3Rfc3RhY2soKSB7XG5cdC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25zb2xlXG5cdGNvbnNvbGUuZXJyb3IoXG5cdFx0J0xhc3QgdGVuIGVmZmVjdHMgd2VyZTogJyxcblx0XHRkZXZfZWZmZWN0X3N0YWNrLnNsaWNlKC0xMCkubWFwKChkKSA9PiBkLmZuKVxuXHQpO1xuXHRkZXZfZWZmZWN0X3N0YWNrID0gW107XG59XG5cbmZ1bmN0aW9uIGluZmluaXRlX2xvb3BfZ3VhcmQoKSB7XG5cdGlmIChmbHVzaF9jb3VudCA+IDEwMDApIHtcblx0XHRmbHVzaF9jb3VudCA9IDA7XG5cdFx0dHJ5IHtcblx0XHRcdGUuZWZmZWN0X3VwZGF0ZV9kZXB0aF9leGNlZWRlZCgpO1xuXHRcdH0gY2F0Y2ggKGVycm9yKSB7XG5cdFx0XHRpZiAoREVWKSB7XG5cdFx0XHRcdC8vIHN0YWNrIGlzIGdhcmJhZ2UsIGlnbm9yZS4gSW5zdGVhZCBhZGQgYSBjb25zb2xlLmVycm9yIG1lc3NhZ2UuXG5cdFx0XHRcdGRlZmluZV9wcm9wZXJ0eShlcnJvciwgJ3N0YWNrJywge1xuXHRcdFx0XHRcdHZhbHVlOiAnJ1xuXHRcdFx0XHR9KTtcblx0XHRcdH1cblx0XHRcdC8vIFRyeSBhbmQgaGFuZGxlIHRoZSBlcnJvciBzbyBpdCBjYW4gYmUgY2F1Z2h0IGF0IGEgYm91bmRhcnksIHRoYXQnc1xuXHRcdFx0Ly8gaWYgdGhlcmUncyBhbiBlZmZlY3QgYXZhaWxhYmxlIGZyb20gd2hlbiBpdCB3YXMgbGFzdCBzY2hlZHVsZWRcblx0XHRcdGlmIChsYXN0X3NjaGVkdWxlZF9lZmZlY3QgIT09IG51bGwpIHtcblx0XHRcdFx0aWYgKERFVikge1xuXHRcdFx0XHRcdHRyeSB7XG5cdFx0XHRcdFx0XHRoYW5kbGVfZXJyb3IoZXJyb3IsIGxhc3Rfc2NoZWR1bGVkX2VmZmVjdCwgbnVsbCwgbnVsbCk7XG5cdFx0XHRcdFx0fSBjYXRjaCAoZSkge1xuXHRcdFx0XHRcdFx0Ly8gT25seSBsb2cgdGhlIGVmZmVjdCBzdGFjayBpZiB0aGUgZXJyb3IgaXMgcmUtdGhyb3duXG5cdFx0XHRcdFx0XHRsb2dfZWZmZWN0X3N0YWNrKCk7XG5cdFx0XHRcdFx0XHR0aHJvdyBlO1xuXHRcdFx0XHRcdH1cblx0XHRcdFx0fSBlbHNlIHtcblx0XHRcdFx0XHRoYW5kbGVfZXJyb3IoZXJyb3IsIGxhc3Rfc2NoZWR1bGVkX2VmZmVjdCwgbnVsbCwgbnVsbCk7XG5cdFx0XHRcdH1cblx0XHRcdH0gZWxzZSB7XG5cdFx0XHRcdGlmIChERVYpIHtcblx0XHRcdFx0XHRsb2dfZWZmZWN0X3N0YWNrKCk7XG5cdFx0XHRcdH1cblx0XHRcdFx0dGhyb3cgZXJyb3I7XG5cdFx0XHR9XG5cdFx0fVxuXHR9XG5cdGZsdXNoX2NvdW50Kys7XG59XG5cbi8qKlxuICogQHBhcmFtIHtBcnJheTxFZmZlY3Q+fSByb290X2VmZmVjdHNcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5mdW5jdGlvbiBmbHVzaF9xdWV1ZWRfcm9vdF9lZmZlY3RzKHJvb3RfZWZmZWN0cykge1xuXHR2YXIgbGVuZ3RoID0gcm9vdF9lZmZlY3RzLmxlbmd0aDtcblx0aWYgKGxlbmd0aCA9PT0gMCkge1xuXHRcdHJldHVybjtcblx0fVxuXHRpbmZpbml0ZV9sb29wX2d1YXJkKCk7XG5cblx0dmFyIHByZXZpb3VzbHlfZmx1c2hpbmdfZWZmZWN0ID0gaXNfZmx1c2hpbmdfZWZmZWN0O1xuXHRpc19mbHVzaGluZ19lZmZlY3QgPSB0cnVlO1xuXG5cdHRyeSB7XG5cdFx0Zm9yICh2YXIgaSA9IDA7IGkgPCBsZW5ndGg7IGkrKykge1xuXHRcdFx0dmFyIGVmZmVjdCA9IHJvb3RfZWZmZWN0c1tpXTtcblxuXHRcdFx0aWYgKChlZmZlY3QuZiAmIENMRUFOKSA9PT0gMCkge1xuXHRcdFx0XHRlZmZlY3QuZiBePSBDTEVBTjtcblx0XHRcdH1cblxuXHRcdFx0dmFyIGNvbGxlY3RlZF9lZmZlY3RzID0gcHJvY2Vzc19lZmZlY3RzKGVmZmVjdCk7XG5cdFx0XHRmbHVzaF9xdWV1ZWRfZWZmZWN0cyhjb2xsZWN0ZWRfZWZmZWN0cyk7XG5cdFx0fVxuXHR9IGZpbmFsbHkge1xuXHRcdGlzX2ZsdXNoaW5nX2VmZmVjdCA9IHByZXZpb3VzbHlfZmx1c2hpbmdfZWZmZWN0O1xuXHR9XG59XG5cbi8qKlxuICogQHBhcmFtIHtBcnJheTxFZmZlY3Q+fSBlZmZlY3RzXG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZnVuY3Rpb24gZmx1c2hfcXVldWVkX2VmZmVjdHMoZWZmZWN0cykge1xuXHR2YXIgbGVuZ3RoID0gZWZmZWN0cy5sZW5ndGg7XG5cdGlmIChsZW5ndGggPT09IDApIHJldHVybjtcblxuXHRmb3IgKHZhciBpID0gMDsgaSA8IGxlbmd0aDsgaSsrKSB7XG5cdFx0dmFyIGVmZmVjdCA9IGVmZmVjdHNbaV07XG5cblx0XHRpZiAoKGVmZmVjdC5mICYgKERFU1RST1lFRCB8IElORVJUKSkgPT09IDApIHtcblx0XHRcdHRyeSB7XG5cdFx0XHRcdGlmIChjaGVja19kaXJ0aW5lc3MoZWZmZWN0KSkge1xuXHRcdFx0XHRcdHVwZGF0ZV9lZmZlY3QoZWZmZWN0KTtcblxuXHRcdFx0XHRcdC8vIEVmZmVjdHMgd2l0aCBubyBkZXBlbmRlbmNpZXMgb3IgdGVhcmRvd24gZG8gbm90IGdldCBhZGRlZCB0byB0aGUgZWZmZWN0IHRyZWUuXG5cdFx0XHRcdFx0Ly8gRGVmZXJyZWQgZWZmZWN0cyAoZS5nLiBgJGVmZmVjdCguLi4pYCkgX2FyZV8gYWRkZWQgdG8gdGhlIHRyZWUgYmVjYXVzZSB3ZVxuXHRcdFx0XHRcdC8vIGRvbid0IGtub3cgaWYgd2UgbmVlZCB0byBrZWVwIHRoZW0gdW50aWwgdGhleSBhcmUgZXhlY3V0ZWQuIERvaW5nIHRoZSBjaGVja1xuXHRcdFx0XHRcdC8vIGhlcmUgKHJhdGhlciB0aGFuIGluIGB1cGRhdGVfZWZmZWN0YCkgYWxsb3dzIHVzIHRvIHNraXAgdGhlIHdvcmsgZm9yXG5cdFx0XHRcdFx0Ly8gaW1tZWRpYXRlIGVmZmVjdHMuXG5cdFx0XHRcdFx0aWYgKGVmZmVjdC5kZXBzID09PSBudWxsICYmIGVmZmVjdC5maXJzdCA9PT0gbnVsbCAmJiBlZmZlY3Qubm9kZXNfc3RhcnQgPT09IG51bGwpIHtcblx0XHRcdFx0XHRcdGlmIChlZmZlY3QudGVhcmRvd24gPT09IG51bGwpIHtcblx0XHRcdFx0XHRcdFx0Ly8gcmVtb3ZlIHRoaXMgZWZmZWN0IGZyb20gdGhlIGdyYXBoXG5cdFx0XHRcdFx0XHRcdHVubGlua19lZmZlY3QoZWZmZWN0KTtcblx0XHRcdFx0XHRcdH0gZWxzZSB7XG5cdFx0XHRcdFx0XHRcdC8vIGtlZXAgdGhlIGVmZmVjdCBpbiB0aGUgZ3JhcGgsIGJ1dCBmcmVlIHVwIHNvbWUgbWVtb3J5XG5cdFx0XHRcdFx0XHRcdGVmZmVjdC5mbiA9IG51bGw7XG5cdFx0XHRcdFx0XHR9XG5cdFx0XHRcdFx0fVxuXHRcdFx0XHR9XG5cdFx0XHR9IGNhdGNoIChlcnJvcikge1xuXHRcdFx0XHRoYW5kbGVfZXJyb3IoZXJyb3IsIGVmZmVjdCwgbnVsbCwgZWZmZWN0LmN0eCk7XG5cdFx0XHR9XG5cdFx0fVxuXHR9XG59XG5cbmZ1bmN0aW9uIHByb2Nlc3NfZGVmZXJyZWQoKSB7XG5cdGlzX21pY3JvX3Rhc2tfcXVldWVkID0gZmFsc2U7XG5cdGlmIChmbHVzaF9jb3VudCA+IDEwMDEpIHtcblx0XHRyZXR1cm47XG5cdH1cblx0Y29uc3QgcHJldmlvdXNfcXVldWVkX3Jvb3RfZWZmZWN0cyA9IHF1ZXVlZF9yb290X2VmZmVjdHM7XG5cdHF1ZXVlZF9yb290X2VmZmVjdHMgPSBbXTtcblx0Zmx1c2hfcXVldWVkX3Jvb3RfZWZmZWN0cyhwcmV2aW91c19xdWV1ZWRfcm9vdF9lZmZlY3RzKTtcblxuXHRpZiAoIWlzX21pY3JvX3Rhc2tfcXVldWVkKSB7XG5cdFx0Zmx1c2hfY291bnQgPSAwO1xuXHRcdGxhc3Rfc2NoZWR1bGVkX2VmZmVjdCA9IG51bGw7XG5cdFx0aWYgKERFVikge1xuXHRcdFx0ZGV2X2VmZmVjdF9zdGFjayA9IFtdO1xuXHRcdH1cblx0fVxufVxuXG4vKipcbiAqIEBwYXJhbSB7RWZmZWN0fSBzaWduYWxcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gc2NoZWR1bGVfZWZmZWN0KHNpZ25hbCkge1xuXHRpZiAoc2NoZWR1bGVyX21vZGUgPT09IEZMVVNIX01JQ1JPVEFTSykge1xuXHRcdGlmICghaXNfbWljcm9fdGFza19xdWV1ZWQpIHtcblx0XHRcdGlzX21pY3JvX3Rhc2tfcXVldWVkID0gdHJ1ZTtcblx0XHRcdHF1ZXVlTWljcm90YXNrKHByb2Nlc3NfZGVmZXJyZWQpO1xuXHRcdH1cblx0fVxuXG5cdGxhc3Rfc2NoZWR1bGVkX2VmZmVjdCA9IHNpZ25hbDtcblxuXHR2YXIgZWZmZWN0ID0gc2lnbmFsO1xuXG5cdHdoaWxlIChlZmZlY3QucGFyZW50ICE9PSBudWxsKSB7XG5cdFx0ZWZmZWN0ID0gZWZmZWN0LnBhcmVudDtcblx0XHR2YXIgZmxhZ3MgPSBlZmZlY3QuZjtcblxuXHRcdGlmICgoZmxhZ3MgJiAoUk9PVF9FRkZFQ1QgfCBCUkFOQ0hfRUZGRUNUKSkgIT09IDApIHtcblx0XHRcdGlmICgoZmxhZ3MgJiBDTEVBTikgPT09IDApIHJldHVybjtcblx0XHRcdGVmZmVjdC5mIF49IENMRUFOO1xuXHRcdH1cblx0fVxuXG5cdHF1ZXVlZF9yb290X2VmZmVjdHMucHVzaChlZmZlY3QpO1xufVxuXG4vKipcbiAqXG4gKiBUaGlzIGZ1bmN0aW9uIGJvdGggcnVucyByZW5kZXIgZWZmZWN0cyBhbmQgY29sbGVjdHMgdXNlciBlZmZlY3RzIGluIHRvcG9sb2dpY2FsIG9yZGVyXG4gKiBmcm9tIHRoZSBzdGFydGluZyBlZmZlY3QgcGFzc2VkIGluLiBFZmZlY3RzIHdpbGwgYmUgY29sbGVjdGVkIHdoZW4gdGhleSBtYXRjaCB0aGUgZmlsdGVyZWRcbiAqIGJpdHdpc2UgZmxhZyBwYXNzZWQgaW4gb25seS4gVGhlIGNvbGxlY3RlZCBlZmZlY3RzIGFycmF5IHdpbGwgYmUgcG9wdWxhdGVkIHdpdGggYWxsIHRoZSB1c2VyXG4gKiBlZmZlY3RzIHRvIGJlIGZsdXNoZWQuXG4gKlxuICogQHBhcmFtIHtFZmZlY3R9IGVmZmVjdFxuICogQHJldHVybnMge0VmZmVjdFtdfVxuICovXG5mdW5jdGlvbiBwcm9jZXNzX2VmZmVjdHMoZWZmZWN0KSB7XG5cdC8qKiBAdHlwZSB7RWZmZWN0W119ICovXG5cdHZhciBlZmZlY3RzID0gW107XG5cblx0dmFyIGN1cnJlbnRfZWZmZWN0ID0gZWZmZWN0LmZpcnN0O1xuXG5cdG1haW5fbG9vcDogd2hpbGUgKGN1cnJlbnRfZWZmZWN0ICE9PSBudWxsKSB7XG5cdFx0dmFyIGZsYWdzID0gY3VycmVudF9lZmZlY3QuZjtcblx0XHR2YXIgaXNfYnJhbmNoID0gKGZsYWdzICYgQlJBTkNIX0VGRkVDVCkgIT09IDA7XG5cdFx0dmFyIGlzX3NraXBwYWJsZV9icmFuY2ggPSBpc19icmFuY2ggJiYgKGZsYWdzICYgQ0xFQU4pICE9PSAwO1xuXHRcdHZhciBzaWJsaW5nID0gY3VycmVudF9lZmZlY3QubmV4dDtcblxuXHRcdGlmICghaXNfc2tpcHBhYmxlX2JyYW5jaCAmJiAoZmxhZ3MgJiBJTkVSVCkgPT09IDApIHtcblx0XHRcdGlmICgoZmxhZ3MgJiBFRkZFQ1QpICE9PSAwKSB7XG5cdFx0XHRcdGVmZmVjdHMucHVzaChjdXJyZW50X2VmZmVjdCk7XG5cdFx0XHR9IGVsc2UgaWYgKGlzX2JyYW5jaCkge1xuXHRcdFx0XHRjdXJyZW50X2VmZmVjdC5mIF49IENMRUFOO1xuXHRcdFx0fSBlbHNlIHtcblx0XHRcdFx0Ly8gRW5zdXJlIHdlIHNldCB0aGUgZWZmZWN0IHRvIGJlIHRoZSBhY3RpdmUgcmVhY3Rpb25cblx0XHRcdFx0Ly8gdG8gZW5zdXJlIHRoYXQgdW5vd25lZCBkZXJpdmVkcyBhcmUgY29ycmVjdGx5IHRyYWNrZWRcblx0XHRcdFx0Ly8gYmVjYXVzZSB3ZSdyZSBmbHVzaGluZyB0aGUgY3VycmVudCBlZmZlY3Rcblx0XHRcdFx0dmFyIHByZXZpb3VzX2FjdGl2ZV9yZWFjdGlvbiA9IGFjdGl2ZV9yZWFjdGlvbjtcblx0XHRcdFx0dHJ5IHtcblx0XHRcdFx0XHRhY3RpdmVfcmVhY3Rpb24gPSBjdXJyZW50X2VmZmVjdDtcblx0XHRcdFx0XHRpZiAoY2hlY2tfZGlydGluZXNzKGN1cnJlbnRfZWZmZWN0KSkge1xuXHRcdFx0XHRcdFx0dXBkYXRlX2VmZmVjdChjdXJyZW50X2VmZmVjdCk7XG5cdFx0XHRcdFx0fVxuXHRcdFx0XHR9IGNhdGNoIChlcnJvcikge1xuXHRcdFx0XHRcdGhhbmRsZV9lcnJvcihlcnJvciwgY3VycmVudF9lZmZlY3QsIG51bGwsIGN1cnJlbnRfZWZmZWN0LmN0eCk7XG5cdFx0XHRcdH0gZmluYWxseSB7XG5cdFx0XHRcdFx0YWN0aXZlX3JlYWN0aW9uID0gcHJldmlvdXNfYWN0aXZlX3JlYWN0aW9uO1xuXHRcdFx0XHR9XG5cdFx0XHR9XG5cblx0XHRcdHZhciBjaGlsZCA9IGN1cnJlbnRfZWZmZWN0LmZpcnN0O1xuXG5cdFx0XHRpZiAoY2hpbGQgIT09IG51bGwpIHtcblx0XHRcdFx0Y3VycmVudF9lZmZlY3QgPSBjaGlsZDtcblx0XHRcdFx0Y29udGludWU7XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0aWYgKHNpYmxpbmcgPT09IG51bGwpIHtcblx0XHRcdGxldCBwYXJlbnQgPSBjdXJyZW50X2VmZmVjdC5wYXJlbnQ7XG5cblx0XHRcdHdoaWxlIChwYXJlbnQgIT09IG51bGwpIHtcblx0XHRcdFx0aWYgKGVmZmVjdCA9PT0gcGFyZW50KSB7XG5cdFx0XHRcdFx0YnJlYWsgbWFpbl9sb29wO1xuXHRcdFx0XHR9XG5cdFx0XHRcdHZhciBwYXJlbnRfc2libGluZyA9IHBhcmVudC5uZXh0O1xuXHRcdFx0XHRpZiAocGFyZW50X3NpYmxpbmcgIT09IG51bGwpIHtcblx0XHRcdFx0XHRjdXJyZW50X2VmZmVjdCA9IHBhcmVudF9zaWJsaW5nO1xuXHRcdFx0XHRcdGNvbnRpbnVlIG1haW5fbG9vcDtcblx0XHRcdFx0fVxuXHRcdFx0XHRwYXJlbnQgPSBwYXJlbnQucGFyZW50O1xuXHRcdFx0fVxuXHRcdH1cblxuXHRcdGN1cnJlbnRfZWZmZWN0ID0gc2libGluZztcblx0fVxuXG5cdHJldHVybiBlZmZlY3RzO1xufVxuXG4vKipcbiAqIEludGVybmFsIHZlcnNpb24gb2YgYGZsdXNoU3luY2Agd2l0aCB0aGUgb3B0aW9uIHRvIG5vdCBmbHVzaCBwcmV2aW91cyBlZmZlY3RzLlxuICogUmV0dXJucyB0aGUgcmVzdWx0IG9mIHRoZSBwYXNzZWQgZnVuY3Rpb24sIGlmIGdpdmVuLlxuICogQHBhcmFtIHsoKSA9PiBhbnl9IFtmbl1cbiAqIEByZXR1cm5zIHthbnl9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBmbHVzaF9zeW5jKGZuKSB7XG5cdHZhciBwcmV2aW91c19zY2hlZHVsZXJfbW9kZSA9IHNjaGVkdWxlcl9tb2RlO1xuXHR2YXIgcHJldmlvdXNfcXVldWVkX3Jvb3RfZWZmZWN0cyA9IHF1ZXVlZF9yb290X2VmZmVjdHM7XG5cblx0dHJ5IHtcblx0XHRpbmZpbml0ZV9sb29wX2d1YXJkKCk7XG5cblx0XHQvKiogQHR5cGUge0VmZmVjdFtdfSAqL1xuXHRcdGNvbnN0IHJvb3RfZWZmZWN0cyA9IFtdO1xuXG5cdFx0c2NoZWR1bGVyX21vZGUgPSBGTFVTSF9TWU5DO1xuXHRcdHF1ZXVlZF9yb290X2VmZmVjdHMgPSByb290X2VmZmVjdHM7XG5cdFx0aXNfbWljcm9fdGFza19xdWV1ZWQgPSBmYWxzZTtcblxuXHRcdGZsdXNoX3F1ZXVlZF9yb290X2VmZmVjdHMocHJldmlvdXNfcXVldWVkX3Jvb3RfZWZmZWN0cyk7XG5cblx0XHR2YXIgcmVzdWx0ID0gZm4/LigpO1xuXG5cdFx0Zmx1c2hfdGFza3MoKTtcblx0XHRpZiAocXVldWVkX3Jvb3RfZWZmZWN0cy5sZW5ndGggPiAwIHx8IHJvb3RfZWZmZWN0cy5sZW5ndGggPiAwKSB7XG5cdFx0XHRmbHVzaF9zeW5jKCk7XG5cdFx0fVxuXG5cdFx0Zmx1c2hfY291bnQgPSAwO1xuXHRcdGxhc3Rfc2NoZWR1bGVkX2VmZmVjdCA9IG51bGw7XG5cdFx0aWYgKERFVikge1xuXHRcdFx0ZGV2X2VmZmVjdF9zdGFjayA9IFtdO1xuXHRcdH1cblxuXHRcdHJldHVybiByZXN1bHQ7XG5cdH0gZmluYWxseSB7XG5cdFx0c2NoZWR1bGVyX21vZGUgPSBwcmV2aW91c19zY2hlZHVsZXJfbW9kZTtcblx0XHRxdWV1ZWRfcm9vdF9lZmZlY3RzID0gcHJldmlvdXNfcXVldWVkX3Jvb3RfZWZmZWN0cztcblx0fVxufVxuXG4vKipcbiAqIFJldHVybnMgYSBwcm9taXNlIHRoYXQgcmVzb2x2ZXMgb25jZSBhbnkgcGVuZGluZyBzdGF0ZSBjaGFuZ2VzIGhhdmUgYmVlbiBhcHBsaWVkLlxuICogQHJldHVybnMge1Byb21pc2U8dm9pZD59XG4gKi9cbmV4cG9ydCBhc3luYyBmdW5jdGlvbiB0aWNrKCkge1xuXHRhd2FpdCBQcm9taXNlLnJlc29sdmUoKTtcblx0Ly8gQnkgY2FsbGluZyBmbHVzaF9zeW5jIHdlIGd1YXJhbnRlZSB0aGF0IGFueSBwZW5kaW5nIHN0YXRlIGNoYW5nZXMgYXJlIGFwcGxpZWQgYWZ0ZXIgb25lIHRpY2suXG5cdC8vIFRPRE8gbG9vayBpbnRvIHdoZXRoZXIgd2UgY2FuIG1ha2UgZmx1c2hpbmcgc3Vic2VxdWVudCB1cGRhdGVzIHN5bmNocm9ub3VzbHkgaW4gdGhlIGZ1dHVyZS5cblx0Zmx1c2hfc3luYygpO1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0ge1ZhbHVlPFY+fSBzaWduYWxcbiAqIEByZXR1cm5zIHtWfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZ2V0KHNpZ25hbCkge1xuXHR2YXIgZmxhZ3MgPSBzaWduYWwuZjtcblx0dmFyIGlzX2Rlcml2ZWQgPSAoZmxhZ3MgJiBERVJJVkVEKSAhPT0gMDtcblxuXHRpZiAoY2FwdHVyZWRfc2lnbmFscyAhPT0gbnVsbCkge1xuXHRcdGNhcHR1cmVkX3NpZ25hbHMuYWRkKHNpZ25hbCk7XG5cdH1cblxuXHQvLyBSZWdpc3RlciB0aGUgZGVwZW5kZW5jeSBvbiB0aGUgY3VycmVudCByZWFjdGlvbiBzaWduYWwuXG5cdGlmIChhY3RpdmVfcmVhY3Rpb24gIT09IG51bGwgJiYgIXVudHJhY2tpbmcpIHtcblx0XHRpZiAoZGVyaXZlZF9zb3VyY2VzICE9PSBudWxsICYmIGRlcml2ZWRfc291cmNlcy5pbmNsdWRlcyhzaWduYWwpKSB7XG5cdFx0XHRlLnN0YXRlX3Vuc2FmZV9sb2NhbF9yZWFkKCk7XG5cdFx0fVxuXHRcdHZhciBkZXBzID0gYWN0aXZlX3JlYWN0aW9uLmRlcHM7XG5cdFx0aWYgKHNpZ25hbC5ydiA8IHJlYWRfdmVyc2lvbikge1xuXHRcdFx0c2lnbmFsLnJ2ID0gcmVhZF92ZXJzaW9uO1xuXHRcdFx0Ly8gSWYgdGhlIHNpZ25hbCBpcyBhY2Nlc3NpbmcgdGhlIHNhbWUgZGVwZW5kZW5jaWVzIGluIHRoZSBzYW1lXG5cdFx0XHQvLyBvcmRlciBhcyBpdCBkaWQgbGFzdCB0aW1lLCBpbmNyZW1lbnQgYHNraXBwZWRfZGVwc2Bcblx0XHRcdC8vIHJhdGhlciB0aGFuIHVwZGF0aW5nIGBuZXdfZGVwc2AsIHdoaWNoIGNyZWF0ZXMgR0MgY29zdFxuXHRcdFx0aWYgKG5ld19kZXBzID09PSBudWxsICYmIGRlcHMgIT09IG51bGwgJiYgZGVwc1tza2lwcGVkX2RlcHNdID09PSBzaWduYWwpIHtcblx0XHRcdFx0c2tpcHBlZF9kZXBzKys7XG5cdFx0XHR9IGVsc2UgaWYgKG5ld19kZXBzID09PSBudWxsKSB7XG5cdFx0XHRcdG5ld19kZXBzID0gW3NpZ25hbF07XG5cdFx0XHR9IGVsc2UgaWYgKCFza2lwX3JlYWN0aW9uIHx8ICFuZXdfZGVwcy5pbmNsdWRlcyhzaWduYWwpKSB7XG5cdFx0XHRcdC8vIE5vcm1hbGx5IHdlIGNhbiBwdXNoIGR1cGxpY2F0ZWQgZGVwZW5kZW5jaWVzIHRvIGBuZXdfZGVwc2AsIGJ1dCBpZiB3ZSdyZSBpbnNpZGVcblx0XHRcdFx0Ly8gYW4gdW5vd25lZCBkZXJpdmVkIGJlY2F1c2Ugc2tpcF9yZWFjdGlvbiBpcyB0cnVlLCB0aGVuIHdlIG5lZWQgdG8gZW5zdXJlIHRoYXRcblx0XHRcdFx0Ly8gd2UgZG9uJ3QgaGF2ZSBkdXBsaWNhdGVzXG5cdFx0XHRcdG5ld19kZXBzLnB1c2goc2lnbmFsKTtcblx0XHRcdH1cblx0XHR9XG5cdH0gZWxzZSBpZiAoXG5cdFx0aXNfZGVyaXZlZCAmJlxuXHRcdC8qKiBAdHlwZSB7RGVyaXZlZH0gKi8gKHNpZ25hbCkuZGVwcyA9PT0gbnVsbCAmJlxuXHRcdC8qKiBAdHlwZSB7RGVyaXZlZH0gKi8gKHNpZ25hbCkuZWZmZWN0cyA9PT0gbnVsbFxuXHQpIHtcblx0XHR2YXIgZGVyaXZlZCA9IC8qKiBAdHlwZSB7RGVyaXZlZH0gKi8gKHNpZ25hbCk7XG5cdFx0dmFyIHBhcmVudCA9IGRlcml2ZWQucGFyZW50O1xuXG5cdFx0aWYgKHBhcmVudCAhPT0gbnVsbCAmJiAocGFyZW50LmYgJiBVTk9XTkVEKSA9PT0gMCkge1xuXHRcdFx0Ly8gSWYgdGhlIGRlcml2ZWQgaXMgb3duZWQgYnkgYW5vdGhlciBkZXJpdmVkIHRoZW4gbWFyayBpdCBhcyB1bm93bmVkXG5cdFx0XHQvLyBhcyB0aGUgZGVyaXZlZCB2YWx1ZSBtaWdodCBoYXZlIGJlZW4gcmVmZXJlbmNlZCBpbiBhIGRpZmZlcmVudCBjb250ZXh0XG5cdFx0XHQvLyBzaW5jZSBhbmQgdGh1cyBpdHMgcGFyZW50IG1pZ2h0IG5vdCBiZSBpdHMgdHJ1ZSBvd25lciBhbnltb3JlXG5cdFx0XHRkZXJpdmVkLmYgXj0gVU5PV05FRDtcblx0XHR9XG5cdH1cblxuXHRpZiAoaXNfZGVyaXZlZCkge1xuXHRcdGRlcml2ZWQgPSAvKiogQHR5cGUge0Rlcml2ZWR9ICovIChzaWduYWwpO1xuXG5cdFx0aWYgKGNoZWNrX2RpcnRpbmVzcyhkZXJpdmVkKSkge1xuXHRcdFx0dXBkYXRlX2Rlcml2ZWQoZGVyaXZlZCk7XG5cdFx0fVxuXHR9XG5cblx0aWYgKFxuXHRcdERFViAmJlxuXHRcdHRyYWNpbmdfbW9kZV9mbGFnICYmXG5cdFx0dHJhY2luZ19leHByZXNzaW9ucyAhPT0gbnVsbCAmJlxuXHRcdGFjdGl2ZV9yZWFjdGlvbiAhPT0gbnVsbCAmJlxuXHRcdHRyYWNpbmdfZXhwcmVzc2lvbnMucmVhY3Rpb24gPT09IGFjdGl2ZV9yZWFjdGlvblxuXHQpIHtcblx0XHQvLyBVc2VkIHdoZW4gbWFwcGluZyBzdGF0ZSBiZXR3ZWVuIHNwZWNpYWwgYmxvY2tzIGxpa2UgYGVhY2hgXG5cdFx0aWYgKHNpZ25hbC5kZWJ1Zykge1xuXHRcdFx0c2lnbmFsLmRlYnVnKCk7XG5cdFx0fSBlbHNlIGlmIChzaWduYWwuY3JlYXRlZCkge1xuXHRcdFx0dmFyIGVudHJ5ID0gdHJhY2luZ19leHByZXNzaW9ucy5lbnRyaWVzLmdldChzaWduYWwpO1xuXG5cdFx0XHRpZiAoZW50cnkgPT09IHVuZGVmaW5lZCkge1xuXHRcdFx0XHRlbnRyeSA9IHsgcmVhZDogW10gfTtcblx0XHRcdFx0dHJhY2luZ19leHByZXNzaW9ucy5lbnRyaWVzLnNldChzaWduYWwsIGVudHJ5KTtcblx0XHRcdH1cblxuXHRcdFx0ZW50cnkucmVhZC5wdXNoKGdldF9zdGFjaygnVHJhY2VkQXQnKSk7XG5cdFx0fVxuXHR9XG5cblx0cmV0dXJuIHNpZ25hbC52O1xufVxuXG4vKipcbiAqIExpa2UgYGdldGAsIGJ1dCBjaGVja3MgZm9yIGB1bmRlZmluZWRgLiBVc2VkIGZvciBgdmFyYCBkZWNsYXJhdGlvbnMgYmVjYXVzZSB0aGV5IGNhbiBiZSBhY2Nlc3NlZCBiZWZvcmUgYmVpbmcgZGVjbGFyZWRcbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0ge1ZhbHVlPFY+IHwgdW5kZWZpbmVkfSBzaWduYWxcbiAqIEByZXR1cm5zIHtWIHwgdW5kZWZpbmVkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gc2FmZV9nZXQoc2lnbmFsKSB7XG5cdHJldHVybiBzaWduYWwgJiYgZ2V0KHNpZ25hbCk7XG59XG5cbi8qKlxuICogQ2FwdHVyZSBhbiBhcnJheSBvZiBhbGwgdGhlIHNpZ25hbHMgdGhhdCBhcmUgcmVhZCB3aGVuIGBmbmAgaXMgY2FsbGVkXG4gKiBAdGVtcGxhdGUgVFxuICogQHBhcmFtIHsoKSA9PiBUfSBmblxuICovXG5leHBvcnQgZnVuY3Rpb24gY2FwdHVyZV9zaWduYWxzKGZuKSB7XG5cdHZhciBwcmV2aW91c19jYXB0dXJlZF9zaWduYWxzID0gY2FwdHVyZWRfc2lnbmFscztcblx0Y2FwdHVyZWRfc2lnbmFscyA9IG5ldyBTZXQoKTtcblxuXHR2YXIgY2FwdHVyZWQgPSBjYXB0dXJlZF9zaWduYWxzO1xuXHR2YXIgc2lnbmFsO1xuXG5cdHRyeSB7XG5cdFx0dW50cmFjayhmbik7XG5cdFx0aWYgKHByZXZpb3VzX2NhcHR1cmVkX3NpZ25hbHMgIT09IG51bGwpIHtcblx0XHRcdGZvciAoc2lnbmFsIG9mIGNhcHR1cmVkX3NpZ25hbHMpIHtcblx0XHRcdFx0cHJldmlvdXNfY2FwdHVyZWRfc2lnbmFscy5hZGQoc2lnbmFsKTtcblx0XHRcdH1cblx0XHR9XG5cdH0gZmluYWxseSB7XG5cdFx0Y2FwdHVyZWRfc2lnbmFscyA9IHByZXZpb3VzX2NhcHR1cmVkX3NpZ25hbHM7XG5cdH1cblxuXHRyZXR1cm4gY2FwdHVyZWQ7XG59XG5cbi8qKlxuICogSW52b2tlcyBhIGZ1bmN0aW9uIGFuZCBjYXB0dXJlcyBhbGwgc2lnbmFscyB0aGF0IGFyZSByZWFkIGR1cmluZyB0aGUgaW52b2NhdGlvbixcbiAqIHRoZW4gaW52YWxpZGF0ZXMgdGhlbS5cbiAqIEBwYXJhbSB7KCkgPT4gYW55fSBmblxuICovXG5leHBvcnQgZnVuY3Rpb24gaW52YWxpZGF0ZV9pbm5lcl9zaWduYWxzKGZuKSB7XG5cdHZhciBjYXB0dXJlZCA9IGNhcHR1cmVfc2lnbmFscygoKSA9PiB1bnRyYWNrKGZuKSk7XG5cblx0Zm9yICh2YXIgc2lnbmFsIG9mIGNhcHR1cmVkKSB7XG5cdFx0Ly8gR28gb25lIGxldmVsIHVwIGJlY2F1c2UgZGVyaXZlZCBzaWduYWxzIGNyZWF0ZWQgYXMgcGFydCBvZiBwcm9wcyBpbiBsZWdhY3kgbW9kZVxuXHRcdGlmICgoc2lnbmFsLmYgJiBMRUdBQ1lfREVSSVZFRF9QUk9QKSAhPT0gMCkge1xuXHRcdFx0Zm9yIChjb25zdCBkZXAgb2YgLyoqIEB0eXBlIHtEZXJpdmVkfSAqLyAoc2lnbmFsKS5kZXBzIHx8IFtdKSB7XG5cdFx0XHRcdGlmICgoZGVwLmYgJiBERVJJVkVEKSA9PT0gMCkge1xuXHRcdFx0XHRcdC8vIFVzZSBpbnRlcm5hbF9zZXQgaW5zdGVhZCBvZiBzZXQgaGVyZSBhbmQgYmVsb3cgdG8gYXZvaWQgbXV0YXRpb24gdmFsaWRhdGlvblxuXHRcdFx0XHRcdGludGVybmFsX3NldChkZXAsIGRlcC52KTtcblx0XHRcdFx0fVxuXHRcdFx0fVxuXHRcdH0gZWxzZSB7XG5cdFx0XHRpbnRlcm5hbF9zZXQoc2lnbmFsLCBzaWduYWwudik7XG5cdFx0fVxuXHR9XG59XG5cbi8qKlxuICogV2hlbiB1c2VkIGluc2lkZSBhIFtgJGRlcml2ZWRgXShodHRwczovL3N2ZWx0ZS5kZXYvZG9jcy9zdmVsdGUvJGRlcml2ZWQpIG9yIFtgJGVmZmVjdGBdKGh0dHBzOi8vc3ZlbHRlLmRldi9kb2NzL3N2ZWx0ZS8kZWZmZWN0KSxcbiAqIGFueSBzdGF0ZSByZWFkIGluc2lkZSBgZm5gIHdpbGwgbm90IGJlIHRyZWF0ZWQgYXMgYSBkZXBlbmRlbmN5LlxuICpcbiAqIGBgYHRzXG4gKiAkZWZmZWN0KCgpID0+IHtcbiAqICAgLy8gdGhpcyB3aWxsIHJ1biB3aGVuIGBkYXRhYCBjaGFuZ2VzLCBidXQgbm90IHdoZW4gYHRpbWVgIGNoYW5nZXNcbiAqICAgc2F2ZShkYXRhLCB7XG4gKiAgICAgdGltZXN0YW1wOiB1bnRyYWNrKCgpID0+IHRpbWUpXG4gKiAgIH0pO1xuICogfSk7XG4gKiBgYGBcbiAqIEB0ZW1wbGF0ZSBUXG4gKiBAcGFyYW0geygpID0+IFR9IGZuXG4gKiBAcmV0dXJucyB7VH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHVudHJhY2soZm4pIHtcblx0dmFyIHByZXZpb3VzX3VudHJhY2tpbmcgPSB1bnRyYWNraW5nO1xuXHR0cnkge1xuXHRcdHVudHJhY2tpbmcgPSB0cnVlO1xuXHRcdHJldHVybiBmbigpO1xuXHR9IGZpbmFsbHkge1xuXHRcdHVudHJhY2tpbmcgPSBwcmV2aW91c191bnRyYWNraW5nO1xuXHR9XG59XG5cbmNvbnN0IFNUQVRVU19NQVNLID0gfihESVJUWSB8IE1BWUJFX0RJUlRZIHwgQ0xFQU4pO1xuXG4vKipcbiAqIEBwYXJhbSB7U2lnbmFsfSBzaWduYWxcbiAqIEBwYXJhbSB7bnVtYmVyfSBzdGF0dXNcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gc2V0X3NpZ25hbF9zdGF0dXMoc2lnbmFsLCBzdGF0dXMpIHtcblx0c2lnbmFsLmYgPSAoc2lnbmFsLmYgJiBTVEFUVVNfTUFTSykgfCBzdGF0dXM7XG59XG5cbi8qKlxuICogQHBhcmFtIHtSZWNvcmQ8c3RyaW5nLCB1bmtub3duPn0gb2JqXG4gKiBAcGFyYW0ge3N0cmluZ1tdfSBrZXlzXG4gKiBAcmV0dXJucyB7UmVjb3JkPHN0cmluZywgdW5rbm93bj59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBleGNsdWRlX2Zyb21fb2JqZWN0KG9iaiwga2V5cykge1xuXHQvKiogQHR5cGUge1JlY29yZDxzdHJpbmcsIHVua25vd24+fSAqL1xuXHR2YXIgcmVzdWx0ID0ge307XG5cblx0Zm9yICh2YXIga2V5IGluIG9iaikge1xuXHRcdGlmICgha2V5cy5pbmNsdWRlcyhrZXkpKSB7XG5cdFx0XHRyZXN1bHRba2V5XSA9IG9ialtrZXldO1xuXHRcdH1cblx0fVxuXG5cdHJldHVybiByZXN1bHQ7XG59XG5cbi8qKlxuICogUG9zc2libHkgdHJhdmVyc2UgYW4gb2JqZWN0IGFuZCByZWFkIGFsbCBpdHMgcHJvcGVydGllcyBzbyB0aGF0IHRoZXkncmUgYWxsIHJlYWN0aXZlIGluIGNhc2UgdGhpcyBpcyBgJHN0YXRlYC5cbiAqIERvZXMgb25seSBjaGVjayBmaXJzdCBsZXZlbCBvZiBhbiBvYmplY3QgZm9yIHBlcmZvcm1hbmNlIHJlYXNvbnMgKGhldXJpc3RpYyBzaG91bGQgYmUgZ29vZCBmb3IgOTklIG9mIGFsbCBjYXNlcykuXG4gKiBAcGFyYW0ge2FueX0gdmFsdWVcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZGVlcF9yZWFkX3N0YXRlKHZhbHVlKSB7XG5cdGlmICh0eXBlb2YgdmFsdWUgIT09ICdvYmplY3QnIHx8ICF2YWx1ZSB8fCB2YWx1ZSBpbnN0YW5jZW9mIEV2ZW50VGFyZ2V0KSB7XG5cdFx0cmV0dXJuO1xuXHR9XG5cblx0aWYgKFNUQVRFX1NZTUJPTCBpbiB2YWx1ZSkge1xuXHRcdGRlZXBfcmVhZCh2YWx1ZSk7XG5cdH0gZWxzZSBpZiAoIUFycmF5LmlzQXJyYXkodmFsdWUpKSB7XG5cdFx0Zm9yIChsZXQga2V5IGluIHZhbHVlKSB7XG5cdFx0XHRjb25zdCBwcm9wID0gdmFsdWVba2V5XTtcblx0XHRcdGlmICh0eXBlb2YgcHJvcCA9PT0gJ29iamVjdCcgJiYgcHJvcCAmJiBTVEFURV9TWU1CT0wgaW4gcHJvcCkge1xuXHRcdFx0XHRkZWVwX3JlYWQocHJvcCk7XG5cdFx0XHR9XG5cdFx0fVxuXHR9XG59XG5cbi8qKlxuICogRGVlcGx5IHRyYXZlcnNlIGFuIG9iamVjdCBhbmQgcmVhZCBhbGwgaXRzIHByb3BlcnRpZXNcbiAqIHNvIHRoYXQgdGhleSdyZSBhbGwgcmVhY3RpdmUgaW4gY2FzZSB0aGlzIGlzIGAkc3RhdGVgXG4gKiBAcGFyYW0ge2FueX0gdmFsdWVcbiAqIEBwYXJhbSB7U2V0PGFueT59IHZpc2l0ZWRcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZGVlcF9yZWFkKHZhbHVlLCB2aXNpdGVkID0gbmV3IFNldCgpKSB7XG5cdGlmIChcblx0XHR0eXBlb2YgdmFsdWUgPT09ICdvYmplY3QnICYmXG5cdFx0dmFsdWUgIT09IG51bGwgJiZcblx0XHQvLyBXZSBkb24ndCB3YW50IHRvIHRyYXZlcnNlIERPTSBlbGVtZW50c1xuXHRcdCEodmFsdWUgaW5zdGFuY2VvZiBFdmVudFRhcmdldCkgJiZcblx0XHQhdmlzaXRlZC5oYXModmFsdWUpXG5cdCkge1xuXHRcdHZpc2l0ZWQuYWRkKHZhbHVlKTtcblx0XHQvLyBXaGVuIHdvcmtpbmcgd2l0aCBhIHBvc3NpYmxlIFN2ZWx0ZURhdGUsIHRoaXNcblx0XHQvLyB3aWxsIGVuc3VyZSB3ZSBjYXB0dXJlIGNoYW5nZXMgdG8gaXQuXG5cdFx0aWYgKHZhbHVlIGluc3RhbmNlb2YgRGF0ZSkge1xuXHRcdFx0dmFsdWUuZ2V0VGltZSgpO1xuXHRcdH1cblx0XHRmb3IgKGxldCBrZXkgaW4gdmFsdWUpIHtcblx0XHRcdHRyeSB7XG5cdFx0XHRcdGRlZXBfcmVhZCh2YWx1ZVtrZXldLCB2aXNpdGVkKTtcblx0XHRcdH0gY2F0Y2ggKGUpIHtcblx0XHRcdFx0Ly8gY29udGludWVcblx0XHRcdH1cblx0XHR9XG5cdFx0Y29uc3QgcHJvdG8gPSBnZXRfcHJvdG90eXBlX29mKHZhbHVlKTtcblx0XHRpZiAoXG5cdFx0XHRwcm90byAhPT0gT2JqZWN0LnByb3RvdHlwZSAmJlxuXHRcdFx0cHJvdG8gIT09IEFycmF5LnByb3RvdHlwZSAmJlxuXHRcdFx0cHJvdG8gIT09IE1hcC5wcm90b3R5cGUgJiZcblx0XHRcdHByb3RvICE9PSBTZXQucHJvdG90eXBlICYmXG5cdFx0XHRwcm90byAhPT0gRGF0ZS5wcm90b3R5cGVcblx0XHQpIHtcblx0XHRcdGNvbnN0IGRlc2NyaXB0b3JzID0gZ2V0X2Rlc2NyaXB0b3JzKHByb3RvKTtcblx0XHRcdGZvciAobGV0IGtleSBpbiBkZXNjcmlwdG9ycykge1xuXHRcdFx0XHRjb25zdCBnZXQgPSBkZXNjcmlwdG9yc1trZXldLmdldDtcblx0XHRcdFx0aWYgKGdldCkge1xuXHRcdFx0XHRcdHRyeSB7XG5cdFx0XHRcdFx0XHRnZXQuY2FsbCh2YWx1ZSk7XG5cdFx0XHRcdFx0fSBjYXRjaCAoZSkge1xuXHRcdFx0XHRcdFx0Ly8gY29udGludWVcblx0XHRcdFx0XHR9XG5cdFx0XHRcdH1cblx0XHRcdH1cblx0XHR9XG5cdH1cbn1cbiIsICJjb25zdCByZWdleF9yZXR1cm5fY2hhcmFjdGVycyA9IC9cXHIvZztcblxuLyoqXG4gKiBAcGFyYW0ge3N0cmluZ30gc3RyXG4gKiBAcmV0dXJucyB7c3RyaW5nfVxuICovXG5leHBvcnQgZnVuY3Rpb24gaGFzaChzdHIpIHtcblx0c3RyID0gc3RyLnJlcGxhY2UocmVnZXhfcmV0dXJuX2NoYXJhY3RlcnMsICcnKTtcblx0bGV0IGhhc2ggPSA1MzgxO1xuXHRsZXQgaSA9IHN0ci5sZW5ndGg7XG5cblx0d2hpbGUgKGktLSkgaGFzaCA9ICgoaGFzaCA8PCA1KSAtIGhhc2gpIF4gc3RyLmNoYXJDb2RlQXQoaSk7XG5cdHJldHVybiAoaGFzaCA+Pj4gMCkudG9TdHJpbmcoMzYpO1xufVxuXG5jb25zdCBWT0lEX0VMRU1FTlRfTkFNRVMgPSBbXG5cdCdhcmVhJyxcblx0J2Jhc2UnLFxuXHQnYnInLFxuXHQnY29sJyxcblx0J2NvbW1hbmQnLFxuXHQnZW1iZWQnLFxuXHQnaHInLFxuXHQnaW1nJyxcblx0J2lucHV0Jyxcblx0J2tleWdlbicsXG5cdCdsaW5rJyxcblx0J21ldGEnLFxuXHQncGFyYW0nLFxuXHQnc291cmNlJyxcblx0J3RyYWNrJyxcblx0J3dicidcbl07XG5cbi8qKlxuICogUmV0dXJucyBgdHJ1ZWAgaWYgYG5hbWVgIGlzIG9mIGEgdm9pZCBlbGVtZW50XG4gKiBAcGFyYW0ge3N0cmluZ30gbmFtZVxuICovXG5leHBvcnQgZnVuY3Rpb24gaXNfdm9pZChuYW1lKSB7XG5cdHJldHVybiBWT0lEX0VMRU1FTlRfTkFNRVMuaW5jbHVkZXMobmFtZSkgfHwgbmFtZS50b0xvd2VyQ2FzZSgpID09PSAnIWRvY3R5cGUnO1xufVxuXG5jb25zdCBSRVNFUlZFRF9XT1JEUyA9IFtcblx0J2FyZ3VtZW50cycsXG5cdCdhd2FpdCcsXG5cdCdicmVhaycsXG5cdCdjYXNlJyxcblx0J2NhdGNoJyxcblx0J2NsYXNzJyxcblx0J2NvbnN0Jyxcblx0J2NvbnRpbnVlJyxcblx0J2RlYnVnZ2VyJyxcblx0J2RlZmF1bHQnLFxuXHQnZGVsZXRlJyxcblx0J2RvJyxcblx0J2Vsc2UnLFxuXHQnZW51bScsXG5cdCdldmFsJyxcblx0J2V4cG9ydCcsXG5cdCdleHRlbmRzJyxcblx0J2ZhbHNlJyxcblx0J2ZpbmFsbHknLFxuXHQnZm9yJyxcblx0J2Z1bmN0aW9uJyxcblx0J2lmJyxcblx0J2ltcGxlbWVudHMnLFxuXHQnaW1wb3J0Jyxcblx0J2luJyxcblx0J2luc3RhbmNlb2YnLFxuXHQnaW50ZXJmYWNlJyxcblx0J2xldCcsXG5cdCduZXcnLFxuXHQnbnVsbCcsXG5cdCdwYWNrYWdlJyxcblx0J3ByaXZhdGUnLFxuXHQncHJvdGVjdGVkJyxcblx0J3B1YmxpYycsXG5cdCdyZXR1cm4nLFxuXHQnc3RhdGljJyxcblx0J3N1cGVyJyxcblx0J3N3aXRjaCcsXG5cdCd0aGlzJyxcblx0J3Rocm93Jyxcblx0J3RydWUnLFxuXHQndHJ5Jyxcblx0J3R5cGVvZicsXG5cdCd2YXInLFxuXHQndm9pZCcsXG5cdCd3aGlsZScsXG5cdCd3aXRoJyxcblx0J3lpZWxkJ1xuXTtcblxuLyoqXG4gKiBSZXR1cm5zIGB0cnVlYCBpZiBgd29yZGAgaXMgYSByZXNlcnZlZCBKYXZhU2NyaXB0IGtleXdvcmRcbiAqIEBwYXJhbSB7c3RyaW5nfSB3b3JkXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBpc19yZXNlcnZlZCh3b3JkKSB7XG5cdHJldHVybiBSRVNFUlZFRF9XT1JEUy5pbmNsdWRlcyh3b3JkKTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge3N0cmluZ30gbmFtZVxuICovXG5leHBvcnQgZnVuY3Rpb24gaXNfY2FwdHVyZV9ldmVudChuYW1lKSB7XG5cdHJldHVybiBuYW1lLmVuZHNXaXRoKCdjYXB0dXJlJykgJiYgbmFtZSAhPT0gJ2dvdHBvaW50ZXJjYXB0dXJlJyAmJiBuYW1lICE9PSAnbG9zdHBvaW50ZXJjYXB0dXJlJztcbn1cblxuLyoqIExpc3Qgb2YgRWxlbWVudCBldmVudHMgdGhhdCB3aWxsIGJlIGRlbGVnYXRlZCAqL1xuY29uc3QgREVMRUdBVEVEX0VWRU5UUyA9IFtcblx0J2JlZm9yZWlucHV0Jyxcblx0J2NsaWNrJyxcblx0J2NoYW5nZScsXG5cdCdkYmxjbGljaycsXG5cdCdjb250ZXh0bWVudScsXG5cdCdmb2N1c2luJyxcblx0J2ZvY3Vzb3V0Jyxcblx0J2lucHV0Jyxcblx0J2tleWRvd24nLFxuXHQna2V5dXAnLFxuXHQnbW91c2Vkb3duJyxcblx0J21vdXNlbW92ZScsXG5cdCdtb3VzZW91dCcsXG5cdCdtb3VzZW92ZXInLFxuXHQnbW91c2V1cCcsXG5cdCdwb2ludGVyZG93bicsXG5cdCdwb2ludGVybW92ZScsXG5cdCdwb2ludGVyb3V0Jyxcblx0J3BvaW50ZXJvdmVyJyxcblx0J3BvaW50ZXJ1cCcsXG5cdCd0b3VjaGVuZCcsXG5cdCd0b3VjaG1vdmUnLFxuXHQndG91Y2hzdGFydCdcbl07XG5cbi8qKlxuICogUmV0dXJucyBgdHJ1ZWAgaWYgYGV2ZW50X25hbWVgIGlzIGEgZGVsZWdhdGVkIGV2ZW50XG4gKiBAcGFyYW0ge3N0cmluZ30gZXZlbnRfbmFtZVxuICovXG5leHBvcnQgZnVuY3Rpb24gaXNfZGVsZWdhdGVkKGV2ZW50X25hbWUpIHtcblx0cmV0dXJuIERFTEVHQVRFRF9FVkVOVFMuaW5jbHVkZXMoZXZlbnRfbmFtZSk7XG59XG5cbi8qKlxuICogQXR0cmlidXRlcyB0aGF0IGFyZSBib29sZWFuLCBpLmUuIHRoZXkgYXJlIHByZXNlbnQgb3Igbm90IHByZXNlbnQuXG4gKi9cbmNvbnN0IERPTV9CT09MRUFOX0FUVFJJQlVURVMgPSBbXG5cdCdhbGxvd2Z1bGxzY3JlZW4nLFxuXHQnYXN5bmMnLFxuXHQnYXV0b2ZvY3VzJyxcblx0J2F1dG9wbGF5Jyxcblx0J2NoZWNrZWQnLFxuXHQnY29udHJvbHMnLFxuXHQnZGVmYXVsdCcsXG5cdCdkaXNhYmxlZCcsXG5cdCdmb3Jtbm92YWxpZGF0ZScsXG5cdCdoaWRkZW4nLFxuXHQnaW5kZXRlcm1pbmF0ZScsXG5cdCdpbmVydCcsXG5cdCdpc21hcCcsXG5cdCdsb29wJyxcblx0J211bHRpcGxlJyxcblx0J211dGVkJyxcblx0J25vbW9kdWxlJyxcblx0J25vdmFsaWRhdGUnLFxuXHQnb3BlbicsXG5cdCdwbGF5c2lubGluZScsXG5cdCdyZWFkb25seScsXG5cdCdyZXF1aXJlZCcsXG5cdCdyZXZlcnNlZCcsXG5cdCdzZWFtbGVzcycsXG5cdCdzZWxlY3RlZCcsXG5cdCd3ZWJraXRkaXJlY3RvcnknLFxuXHQnZGVmZXInLFxuXHQnZGlzYWJsZXBpY3R1cmVpbnBpY3R1cmUnLFxuXHQnZGlzYWJsZXJlbW90ZXBsYXliYWNrJ1xuXTtcblxuLyoqXG4gKiBSZXR1cm5zIGB0cnVlYCBpZiBgbmFtZWAgaXMgYSBib29sZWFuIGF0dHJpYnV0ZVxuICogQHBhcmFtIHtzdHJpbmd9IG5hbWVcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGlzX2Jvb2xlYW5fYXR0cmlidXRlKG5hbWUpIHtcblx0cmV0dXJuIERPTV9CT09MRUFOX0FUVFJJQlVURVMuaW5jbHVkZXMobmFtZSk7XG59XG5cbi8qKlxuICogQHR5cGUge1JlY29yZDxzdHJpbmcsIHN0cmluZz59XG4gKiBMaXN0IG9mIGF0dHJpYnV0ZSBuYW1lcyB0aGF0IHNob3VsZCBiZSBhbGlhc2VkIHRvIHRoZWlyIHByb3BlcnR5IG5hbWVzXG4gKiBiZWNhdXNlIHRoZXkgYmVoYXZlIGRpZmZlcmVudGx5IGJldHdlZW4gc2V0dGluZyB0aGVtIGFzIGFuIGF0dHJpYnV0ZSBhbmRcbiAqIHNldHRpbmcgdGhlbSBhcyBhIHByb3BlcnR5LlxuICovXG5jb25zdCBBVFRSSUJVVEVfQUxJQVNFUyA9IHtcblx0Ly8gbm8gYGNsYXNzOiAnY2xhc3NOYW1lJ2AgYmVjYXVzZSB3ZSBoYW5kbGUgdGhhdCBzZXBhcmF0ZWx5XG5cdGZvcm1ub3ZhbGlkYXRlOiAnZm9ybU5vVmFsaWRhdGUnLFxuXHRpc21hcDogJ2lzTWFwJyxcblx0bm9tb2R1bGU6ICdub01vZHVsZScsXG5cdHBsYXlzaW5saW5lOiAncGxheXNJbmxpbmUnLFxuXHRyZWFkb25seTogJ3JlYWRPbmx5Jyxcblx0ZGVmYXVsdHZhbHVlOiAnZGVmYXVsdFZhbHVlJyxcblx0ZGVmYXVsdGNoZWNrZWQ6ICdkZWZhdWx0Q2hlY2tlZCcsXG5cdHNyY29iamVjdDogJ3NyY09iamVjdCcsXG5cdG5vdmFsaWRhdGU6ICdub1ZhbGlkYXRlJyxcblx0YWxsb3dmdWxsc2NyZWVuOiAnYWxsb3dGdWxsc2NyZWVuJyxcblx0ZGlzYWJsZXBpY3R1cmVpbnBpY3R1cmU6ICdkaXNhYmxlUGljdHVyZUluUGljdHVyZScsXG5cdGRpc2FibGVyZW1vdGVwbGF5YmFjazogJ2Rpc2FibGVSZW1vdGVQbGF5YmFjaydcbn07XG5cbi8qKlxuICogQHBhcmFtIHtzdHJpbmd9IG5hbWVcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIG5vcm1hbGl6ZV9hdHRyaWJ1dGUobmFtZSkge1xuXHRuYW1lID0gbmFtZS50b0xvd2VyQ2FzZSgpO1xuXHRyZXR1cm4gQVRUUklCVVRFX0FMSUFTRVNbbmFtZV0gPz8gbmFtZTtcbn1cblxuY29uc3QgRE9NX1BST1BFUlRJRVMgPSBbXG5cdC4uLkRPTV9CT09MRUFOX0FUVFJJQlVURVMsXG5cdCdmb3JtTm9WYWxpZGF0ZScsXG5cdCdpc01hcCcsXG5cdCdub01vZHVsZScsXG5cdCdwbGF5c0lubGluZScsXG5cdCdyZWFkT25seScsXG5cdCd2YWx1ZScsXG5cdCd2b2x1bWUnLFxuXHQnZGVmYXVsdFZhbHVlJyxcblx0J2RlZmF1bHRDaGVja2VkJyxcblx0J3NyY09iamVjdCcsXG5cdCdub1ZhbGlkYXRlJyxcblx0J2FsbG93RnVsbHNjcmVlbicsXG5cdCdkaXNhYmxlUGljdHVyZUluUGljdHVyZScsXG5cdCdkaXNhYmxlUmVtb3RlUGxheWJhY2snXG5dO1xuXG4vKipcbiAqIEBwYXJhbSB7c3RyaW5nfSBuYW1lXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBpc19kb21fcHJvcGVydHkobmFtZSkge1xuXHRyZXR1cm4gRE9NX1BST1BFUlRJRVMuaW5jbHVkZXMobmFtZSk7XG59XG5cbmNvbnN0IE5PTl9TVEFUSUNfUFJPUEVSVElFUyA9IFsnYXV0b2ZvY3VzJywgJ211dGVkJywgJ2RlZmF1bHRWYWx1ZScsICdkZWZhdWx0Q2hlY2tlZCddO1xuXG4vKipcbiAqIFJldHVybnMgYHRydWVgIGlmIHRoZSBnaXZlbiBhdHRyaWJ1dGUgY2Fubm90IGJlIHNldCB0aHJvdWdoIHRoZSB0ZW1wbGF0ZVxuICogc3RyaW5nLCBpLmUuIG5lZWRzIHNvbWUga2luZCBvZiBKYXZhU2NyaXB0IGhhbmRsaW5nIHRvIHdvcmsuXG4gKiBAcGFyYW0ge3N0cmluZ30gbmFtZVxuICovXG5leHBvcnQgZnVuY3Rpb24gY2Fubm90X2JlX3NldF9zdGF0aWNhbGx5KG5hbWUpIHtcblx0cmV0dXJuIE5PTl9TVEFUSUNfUFJPUEVSVElFUy5pbmNsdWRlcyhuYW1lKTtcbn1cblxuLyoqXG4gKiBTdWJzZXQgb2YgZGVsZWdhdGVkIGV2ZW50cyB3aGljaCBzaG91bGQgYmUgcGFzc2l2ZSBieSBkZWZhdWx0LlxuICogVGhlc2UgdHdvIGFyZSBhbHJlYWR5IHBhc3NpdmUgdmlhIGJyb3dzZXIgZGVmYXVsdHMgb24gd2luZG93LCBkb2N1bWVudCBhbmQgYm9keS5cbiAqIEJ1dCBzaW5jZVxuICogLSB3ZSdyZSBkZWxlZ2F0aW5nIHRoZW1cbiAqIC0gdGhleSBoYXBwZW4gb2Z0ZW5cbiAqIC0gdGhleSBhcHBseSB0byBtb2JpbGUgd2hpY2ggaXMgZ2VuZXJhbGx5IGxlc3MgcGVyZm9ybWFudFxuICogd2UncmUgbWFya2luZyB0aGVtIGFzIHBhc3NpdmUgYnkgZGVmYXVsdCBmb3Igb3RoZXIgZWxlbWVudHMsIHRvby5cbiAqL1xuY29uc3QgUEFTU0lWRV9FVkVOVFMgPSBbJ3RvdWNoc3RhcnQnLCAndG91Y2htb3ZlJ107XG5cbi8qKlxuICogUmV0dXJucyBgdHJ1ZWAgaWYgYG5hbWVgIGlzIGEgcGFzc2l2ZSBldmVudFxuICogQHBhcmFtIHtzdHJpbmd9IG5hbWVcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGlzX3Bhc3NpdmVfZXZlbnQobmFtZSkge1xuXHRyZXR1cm4gUEFTU0lWRV9FVkVOVFMuaW5jbHVkZXMobmFtZSk7XG59XG5cbmNvbnN0IENPTlRFTlRfRURJVEFCTEVfQklORElOR1MgPSBbJ3RleHRDb250ZW50JywgJ2lubmVySFRNTCcsICdpbm5lclRleHQnXTtcblxuLyoqIEBwYXJhbSB7c3RyaW5nfSBuYW1lICovXG5leHBvcnQgZnVuY3Rpb24gaXNfY29udGVudF9lZGl0YWJsZV9iaW5kaW5nKG5hbWUpIHtcblx0cmV0dXJuIENPTlRFTlRfRURJVEFCTEVfQklORElOR1MuaW5jbHVkZXMobmFtZSk7XG59XG5cbmNvbnN0IExPQURfRVJST1JfRUxFTUVOVFMgPSBbXG5cdCdib2R5Jyxcblx0J2VtYmVkJyxcblx0J2lmcmFtZScsXG5cdCdpbWcnLFxuXHQnbGluaycsXG5cdCdvYmplY3QnLFxuXHQnc2NyaXB0Jyxcblx0J3N0eWxlJyxcblx0J3RyYWNrJ1xuXTtcblxuLyoqXG4gKiBSZXR1cm5zIGB0cnVlYCBpZiB0aGUgZWxlbWVudCBlbWl0cyBgbG9hZGAgYW5kIGBlcnJvcmAgZXZlbnRzXG4gKiBAcGFyYW0ge3N0cmluZ30gbmFtZVxuICovXG5leHBvcnQgZnVuY3Rpb24gaXNfbG9hZF9lcnJvcl9lbGVtZW50KG5hbWUpIHtcblx0cmV0dXJuIExPQURfRVJST1JfRUxFTUVOVFMuaW5jbHVkZXMobmFtZSk7XG59XG5cbmNvbnN0IFNWR19FTEVNRU5UUyA9IFtcblx0J2FsdEdseXBoJyxcblx0J2FsdEdseXBoRGVmJyxcblx0J2FsdEdseXBoSXRlbScsXG5cdCdhbmltYXRlJyxcblx0J2FuaW1hdGVDb2xvcicsXG5cdCdhbmltYXRlTW90aW9uJyxcblx0J2FuaW1hdGVUcmFuc2Zvcm0nLFxuXHQnY2lyY2xlJyxcblx0J2NsaXBQYXRoJyxcblx0J2NvbG9yLXByb2ZpbGUnLFxuXHQnY3Vyc29yJyxcblx0J2RlZnMnLFxuXHQnZGVzYycsXG5cdCdkaXNjYXJkJyxcblx0J2VsbGlwc2UnLFxuXHQnZmVCbGVuZCcsXG5cdCdmZUNvbG9yTWF0cml4Jyxcblx0J2ZlQ29tcG9uZW50VHJhbnNmZXInLFxuXHQnZmVDb21wb3NpdGUnLFxuXHQnZmVDb252b2x2ZU1hdHJpeCcsXG5cdCdmZURpZmZ1c2VMaWdodGluZycsXG5cdCdmZURpc3BsYWNlbWVudE1hcCcsXG5cdCdmZURpc3RhbnRMaWdodCcsXG5cdCdmZURyb3BTaGFkb3cnLFxuXHQnZmVGbG9vZCcsXG5cdCdmZUZ1bmNBJyxcblx0J2ZlRnVuY0InLFxuXHQnZmVGdW5jRycsXG5cdCdmZUZ1bmNSJyxcblx0J2ZlR2F1c3NpYW5CbHVyJyxcblx0J2ZlSW1hZ2UnLFxuXHQnZmVNZXJnZScsXG5cdCdmZU1lcmdlTm9kZScsXG5cdCdmZU1vcnBob2xvZ3knLFxuXHQnZmVPZmZzZXQnLFxuXHQnZmVQb2ludExpZ2h0Jyxcblx0J2ZlU3BlY3VsYXJMaWdodGluZycsXG5cdCdmZVNwb3RMaWdodCcsXG5cdCdmZVRpbGUnLFxuXHQnZmVUdXJidWxlbmNlJyxcblx0J2ZpbHRlcicsXG5cdCdmb250Jyxcblx0J2ZvbnQtZmFjZScsXG5cdCdmb250LWZhY2UtZm9ybWF0Jyxcblx0J2ZvbnQtZmFjZS1uYW1lJyxcblx0J2ZvbnQtZmFjZS1zcmMnLFxuXHQnZm9udC1mYWNlLXVyaScsXG5cdCdmb3JlaWduT2JqZWN0Jyxcblx0J2cnLFxuXHQnZ2x5cGgnLFxuXHQnZ2x5cGhSZWYnLFxuXHQnaGF0Y2gnLFxuXHQnaGF0Y2hwYXRoJyxcblx0J2hrZXJuJyxcblx0J2ltYWdlJyxcblx0J2xpbmUnLFxuXHQnbGluZWFyR3JhZGllbnQnLFxuXHQnbWFya2VyJyxcblx0J21hc2snLFxuXHQnbWVzaCcsXG5cdCdtZXNoZ3JhZGllbnQnLFxuXHQnbWVzaHBhdGNoJyxcblx0J21lc2hyb3cnLFxuXHQnbWV0YWRhdGEnLFxuXHQnbWlzc2luZy1nbHlwaCcsXG5cdCdtcGF0aCcsXG5cdCdwYXRoJyxcblx0J3BhdHRlcm4nLFxuXHQncG9seWdvbicsXG5cdCdwb2x5bGluZScsXG5cdCdyYWRpYWxHcmFkaWVudCcsXG5cdCdyZWN0Jyxcblx0J3NldCcsXG5cdCdzb2xpZGNvbG9yJyxcblx0J3N0b3AnLFxuXHQnc3ZnJyxcblx0J3N3aXRjaCcsXG5cdCdzeW1ib2wnLFxuXHQndGV4dCcsXG5cdCd0ZXh0UGF0aCcsXG5cdCd0cmVmJyxcblx0J3RzcGFuJyxcblx0J3Vua25vd24nLFxuXHQndXNlJyxcblx0J3ZpZXcnLFxuXHQndmtlcm4nXG5dO1xuXG4vKiogQHBhcmFtIHtzdHJpbmd9IG5hbWUgKi9cbmV4cG9ydCBmdW5jdGlvbiBpc19zdmcobmFtZSkge1xuXHRyZXR1cm4gU1ZHX0VMRU1FTlRTLmluY2x1ZGVzKG5hbWUpO1xufVxuXG5jb25zdCBNQVRITUxfRUxFTUVOVFMgPSBbXG5cdCdhbm5vdGF0aW9uJyxcblx0J2Fubm90YXRpb24teG1sJyxcblx0J21hY3Rpb24nLFxuXHQnbWF0aCcsXG5cdCdtZXJyb3InLFxuXHQnbWZyYWMnLFxuXHQnbWknLFxuXHQnbW11bHRpc2NyaXB0cycsXG5cdCdtbicsXG5cdCdtbycsXG5cdCdtb3ZlcicsXG5cdCdtcGFkZGVkJyxcblx0J21waGFudG9tJyxcblx0J21wcmVzY3JpcHRzJyxcblx0J21yb290Jyxcblx0J21yb3cnLFxuXHQnbXMnLFxuXHQnbXNwYWNlJyxcblx0J21zcXJ0Jyxcblx0J21zdHlsZScsXG5cdCdtc3ViJyxcblx0J21zdWJzdXAnLFxuXHQnbXN1cCcsXG5cdCdtdGFibGUnLFxuXHQnbXRkJyxcblx0J210ZXh0Jyxcblx0J210cicsXG5cdCdtdW5kZXInLFxuXHQnbXVuZGVyb3ZlcicsXG5cdCdzZW1hbnRpY3MnXG5dO1xuXG4vKiogQHBhcmFtIHtzdHJpbmd9IG5hbWUgKi9cbmV4cG9ydCBmdW5jdGlvbiBpc19tYXRobWwobmFtZSkge1xuXHRyZXR1cm4gTUFUSE1MX0VMRU1FTlRTLmluY2x1ZGVzKG5hbWUpO1xufVxuXG5jb25zdCBSVU5FUyA9IC8qKiBAdHlwZSB7Y29uc3R9ICovIChbXG5cdCckc3RhdGUnLFxuXHQnJHN0YXRlLnJhdycsXG5cdCckc3RhdGUuc25hcHNob3QnLFxuXHQnJHByb3BzJyxcblx0JyRwcm9wcy5pZCcsXG5cdCckYmluZGFibGUnLFxuXHQnJGRlcml2ZWQnLFxuXHQnJGRlcml2ZWQuYnknLFxuXHQnJGVmZmVjdCcsXG5cdCckZWZmZWN0LnByZScsXG5cdCckZWZmZWN0LnRyYWNraW5nJyxcblx0JyRlZmZlY3Qucm9vdCcsXG5cdCckaW5zcGVjdCcsXG5cdCckaW5zcGVjdCgpLndpdGgnLFxuXHQnJGluc3BlY3QudHJhY2UnLFxuXHQnJGhvc3QnXG5dKTtcblxuLyoqXG4gKiBAcGFyYW0ge3N0cmluZ30gbmFtZVxuICogQHJldHVybnMge25hbWUgaXMgUlVORVNbbnVtYmVyXX1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGlzX3J1bmUobmFtZSkge1xuXHRyZXR1cm4gUlVORVMuaW5jbHVkZXMoLyoqIEB0eXBlIHtSVU5FU1tudW1iZXJdfSAqLyAobmFtZSkpO1xufVxuXG4vKiogTGlzdCBvZiBlbGVtZW50cyB0aGF0IHJlcXVpcmUgcmF3IGNvbnRlbnRzIGFuZCBzaG91bGQgbm90IGhhdmUgU1NSIGNvbW1lbnRzIHB1dCBpbiB0aGVtICovXG5jb25zdCBSQVdfVEVYVF9FTEVNRU5UUyA9IC8qKiBAdHlwZSB7Y29uc3R9ICovIChbJ3RleHRhcmVhJywgJ3NjcmlwdCcsICdzdHlsZScsICd0aXRsZSddKTtcblxuLyoqIEBwYXJhbSB7c3RyaW5nfSBuYW1lICovXG5leHBvcnQgZnVuY3Rpb24gaXNfcmF3X3RleHRfZWxlbWVudChuYW1lKSB7XG5cdHJldHVybiBSQVdfVEVYVF9FTEVNRU5UUy5pbmNsdWRlcygvKiogQHR5cGUge1JBV19URVhUX0VMRU1FTlRTW251bWJlcl19ICovIChuYW1lKSk7XG59XG5cbi8qKlxuICogUHJldmVudCBkZXZ0b29scyB0cnlpbmcgdG8gbWFrZSBgbG9jYXRpb25gIGEgY2xpY2thYmxlIGxpbmsgYnkgaW5zZXJ0aW5nIGEgemVyby13aWR0aCBzcGFjZVxuICogQHBhcmFtIHtzdHJpbmcgfCB1bmRlZmluZWR9IGxvY2F0aW9uXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzYW5pdGl6ZV9sb2NhdGlvbihsb2NhdGlvbikge1xuXHRyZXR1cm4gbG9jYXRpb24/LnJlcGxhY2UoL1xcLy9nLCAnL1xcdTIwMGInKTtcbn1cbiIsICIvKiogQGltcG9ydCB7IExvY2F0aW9uIH0gZnJvbSAnbG9jYXRlLWNoYXJhY3RlcicgKi9cbmltcG9ydCB7IHRlYXJkb3duIH0gZnJvbSAnLi4vLi4vcmVhY3Rpdml0eS9lZmZlY3RzLmpzJztcbmltcG9ydCB7IGRlZmluZV9wcm9wZXJ0eSwgaXNfYXJyYXkgfSBmcm9tICcuLi8uLi8uLi9zaGFyZWQvdXRpbHMuanMnO1xuaW1wb3J0IHsgaHlkcmF0aW5nIH0gZnJvbSAnLi4vaHlkcmF0aW9uLmpzJztcbmltcG9ydCB7IHF1ZXVlX21pY3JvX3Rhc2sgfSBmcm9tICcuLi90YXNrLmpzJztcbmltcG9ydCB7IEZJTEVOQU1FIH0gZnJvbSAnLi4vLi4vLi4vLi4vY29uc3RhbnRzLmpzJztcbmltcG9ydCAqIGFzIHcgZnJvbSAnLi4vLi4vd2FybmluZ3MuanMnO1xuaW1wb3J0IHtcblx0YWN0aXZlX2VmZmVjdCxcblx0YWN0aXZlX3JlYWN0aW9uLFxuXHRzZXRfYWN0aXZlX2VmZmVjdCxcblx0c2V0X2FjdGl2ZV9yZWFjdGlvblxufSBmcm9tICcuLi8uLi9ydW50aW1lLmpzJztcbmltcG9ydCB7IHdpdGhvdXRfcmVhY3RpdmVfY29udGV4dCB9IGZyb20gJy4vYmluZGluZ3Mvc2hhcmVkLmpzJztcblxuLyoqIEB0eXBlIHtTZXQ8c3RyaW5nPn0gKi9cbmV4cG9ydCBjb25zdCBhbGxfcmVnaXN0ZXJlZF9ldmVudHMgPSBuZXcgU2V0KCk7XG5cbi8qKiBAdHlwZSB7U2V0PChldmVudHM6IEFycmF5PHN0cmluZz4pID0+IHZvaWQ+fSAqL1xuZXhwb3J0IGNvbnN0IHJvb3RfZXZlbnRfaGFuZGxlcyA9IG5ldyBTZXQoKTtcblxuLyoqXG4gKiBTU1IgYWRkcyBvbmxvYWQgYW5kIG9uZXJyb3IgYXR0cmlidXRlcyB0byBjYXRjaCB0aG9zZSBldmVudHMgYmVmb3JlIHRoZSBoeWRyYXRpb24uXG4gKiBUaGlzIGZ1bmN0aW9uIGRldGVjdHMgdGhvc2UgY2FzZXMsIHJlbW92ZXMgdGhlIGF0dHJpYnV0ZXMgYW5kIHJlcGxheXMgdGhlIGV2ZW50cy5cbiAqIEBwYXJhbSB7SFRNTEVsZW1lbnR9IGRvbVxuICovXG5leHBvcnQgZnVuY3Rpb24gcmVwbGF5X2V2ZW50cyhkb20pIHtcblx0aWYgKCFoeWRyYXRpbmcpIHJldHVybjtcblxuXHRpZiAoZG9tLm9ubG9hZCkge1xuXHRcdGRvbS5yZW1vdmVBdHRyaWJ1dGUoJ29ubG9hZCcpO1xuXHR9XG5cdGlmIChkb20ub25lcnJvcikge1xuXHRcdGRvbS5yZW1vdmVBdHRyaWJ1dGUoJ29uZXJyb3InKTtcblx0fVxuXHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdGNvbnN0IGV2ZW50ID0gZG9tLl9fZTtcblx0aWYgKGV2ZW50ICE9PSB1bmRlZmluZWQpIHtcblx0XHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdFx0ZG9tLl9fZSA9IHVuZGVmaW5lZDtcblx0XHRxdWV1ZU1pY3JvdGFzaygoKSA9PiB7XG5cdFx0XHRpZiAoZG9tLmlzQ29ubmVjdGVkKSB7XG5cdFx0XHRcdGRvbS5kaXNwYXRjaEV2ZW50KGV2ZW50KTtcblx0XHRcdH1cblx0XHR9KTtcblx0fVxufVxuXG4vKipcbiAqIEBwYXJhbSB7c3RyaW5nfSBldmVudF9uYW1lXG4gKiBAcGFyYW0ge0V2ZW50VGFyZ2V0fSBkb21cbiAqIEBwYXJhbSB7RXZlbnRMaXN0ZW5lcn0gW2hhbmRsZXJdXG4gKiBAcGFyYW0ge0FkZEV2ZW50TGlzdGVuZXJPcHRpb25zfSBbb3B0aW9uc11cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGNyZWF0ZV9ldmVudChldmVudF9uYW1lLCBkb20sIGhhbmRsZXIsIG9wdGlvbnMgPSB7fSkge1xuXHQvKipcblx0ICogQHRoaXMge0V2ZW50VGFyZ2V0fVxuXHQgKi9cblx0ZnVuY3Rpb24gdGFyZ2V0X2hhbmRsZXIoLyoqIEB0eXBlIHtFdmVudH0gKi8gZXZlbnQpIHtcblx0XHRpZiAoIW9wdGlvbnMuY2FwdHVyZSkge1xuXHRcdFx0Ly8gT25seSBjYWxsIGluIHRoZSBidWJibGUgcGhhc2UsIGVsc2UgZGVsZWdhdGVkIGV2ZW50cyB3b3VsZCBiZSBjYWxsZWQgYmVmb3JlIHRoZSBjYXB0dXJpbmcgZXZlbnRzXG5cdFx0XHRoYW5kbGVfZXZlbnRfcHJvcGFnYXRpb24uY2FsbChkb20sIGV2ZW50KTtcblx0XHR9XG5cdFx0aWYgKCFldmVudC5jYW5jZWxCdWJibGUpIHtcblx0XHRcdHJldHVybiB3aXRob3V0X3JlYWN0aXZlX2NvbnRleHQoKCkgPT4ge1xuXHRcdFx0XHRyZXR1cm4gaGFuZGxlcj8uY2FsbCh0aGlzLCBldmVudCk7XG5cdFx0XHR9KTtcblx0XHR9XG5cdH1cblxuXHQvLyBDaHJvbWUgaGFzIGEgYnVnIHdoZXJlIHBvaW50ZXIgZXZlbnRzIGRvbid0IHdvcmsgd2hlbiBhdHRhY2hlZCB0byBhIERPTSBlbGVtZW50IHRoYXQgaGFzIGJlZW4gY2xvbmVkXG5cdC8vIHdpdGggY2xvbmVOb2RlKCkgYW5kIHRoZSBET00gZWxlbWVudCBpcyBkaXNjb25uZWN0ZWQgZnJvbSB0aGUgZG9jdW1lbnQuIFRvIGVuc3VyZSB0aGUgZXZlbnQgd29ya3MsIHdlXG5cdC8vIGRlZmVyIHRoZSBhdHRhY2htZW50IHRpbGwgYWZ0ZXIgaXQncyBiZWVuIGFwcGVuZGVkIHRvIHRoZSBkb2N1bWVudC4gVE9ETzogcmVtb3ZlIHRoaXMgb25jZSBDaHJvbWUgZml4ZXNcblx0Ly8gdGhpcyBidWcuIFRoZSBzYW1lIGFwcGxpZXMgdG8gd2hlZWwgZXZlbnRzIGFuZCB0b3VjaCBldmVudHMuXG5cdGlmIChcblx0XHRldmVudF9uYW1lLnN0YXJ0c1dpdGgoJ3BvaW50ZXInKSB8fFxuXHRcdGV2ZW50X25hbWUuc3RhcnRzV2l0aCgndG91Y2gnKSB8fFxuXHRcdGV2ZW50X25hbWUgPT09ICd3aGVlbCdcblx0KSB7XG5cdFx0cXVldWVfbWljcm9fdGFzaygoKSA9PiB7XG5cdFx0XHRkb20uYWRkRXZlbnRMaXN0ZW5lcihldmVudF9uYW1lLCB0YXJnZXRfaGFuZGxlciwgb3B0aW9ucyk7XG5cdFx0fSk7XG5cdH0gZWxzZSB7XG5cdFx0ZG9tLmFkZEV2ZW50TGlzdGVuZXIoZXZlbnRfbmFtZSwgdGFyZ2V0X2hhbmRsZXIsIG9wdGlvbnMpO1xuXHR9XG5cblx0cmV0dXJuIHRhcmdldF9oYW5kbGVyO1xufVxuXG4vKipcbiAqIEF0dGFjaGVzIGFuIGV2ZW50IGhhbmRsZXIgdG8gYW4gZWxlbWVudCBhbmQgcmV0dXJucyBhIGZ1bmN0aW9uIHRoYXQgcmVtb3ZlcyB0aGUgaGFuZGxlci4gVXNpbmcgdGhpc1xuICogcmF0aGVyIHRoYW4gYGFkZEV2ZW50TGlzdGVuZXJgIHdpbGwgcHJlc2VydmUgdGhlIGNvcnJlY3Qgb3JkZXIgcmVsYXRpdmUgdG8gaGFuZGxlcnMgYWRkZWQgZGVjbGFyYXRpdmVseVxuICogKHdpdGggYXR0cmlidXRlcyBsaWtlIGBvbmNsaWNrYCksIHdoaWNoIHVzZSBldmVudCBkZWxlZ2F0aW9uIGZvciBwZXJmb3JtYW5jZSByZWFzb25zXG4gKlxuICogQHBhcmFtIHtFdmVudFRhcmdldH0gZWxlbWVudFxuICogQHBhcmFtIHtzdHJpbmd9IHR5cGVcbiAqIEBwYXJhbSB7RXZlbnRMaXN0ZW5lcn0gaGFuZGxlclxuICogQHBhcmFtIHtBZGRFdmVudExpc3RlbmVyT3B0aW9uc30gW29wdGlvbnNdXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBvbihlbGVtZW50LCB0eXBlLCBoYW5kbGVyLCBvcHRpb25zID0ge30pIHtcblx0dmFyIHRhcmdldF9oYW5kbGVyID0gY3JlYXRlX2V2ZW50KHR5cGUsIGVsZW1lbnQsIGhhbmRsZXIsIG9wdGlvbnMpO1xuXG5cdHJldHVybiAoKSA9PiB7XG5cdFx0ZWxlbWVudC5yZW1vdmVFdmVudExpc3RlbmVyKHR5cGUsIHRhcmdldF9oYW5kbGVyLCBvcHRpb25zKTtcblx0fTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge3N0cmluZ30gZXZlbnRfbmFtZVxuICogQHBhcmFtIHtFbGVtZW50fSBkb21cbiAqIEBwYXJhbSB7RXZlbnRMaXN0ZW5lcn0gW2hhbmRsZXJdXG4gKiBAcGFyYW0ge2Jvb2xlYW59IFtjYXB0dXJlXVxuICogQHBhcmFtIHtib29sZWFufSBbcGFzc2l2ZV1cbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZXZlbnQoZXZlbnRfbmFtZSwgZG9tLCBoYW5kbGVyLCBjYXB0dXJlLCBwYXNzaXZlKSB7XG5cdHZhciBvcHRpb25zID0geyBjYXB0dXJlLCBwYXNzaXZlIH07XG5cdHZhciB0YXJnZXRfaGFuZGxlciA9IGNyZWF0ZV9ldmVudChldmVudF9uYW1lLCBkb20sIGhhbmRsZXIsIG9wdGlvbnMpO1xuXG5cdC8vIEB0cy1pZ25vcmVcblx0aWYgKGRvbSA9PT0gZG9jdW1lbnQuYm9keSB8fCBkb20gPT09IHdpbmRvdyB8fCBkb20gPT09IGRvY3VtZW50KSB7XG5cdFx0dGVhcmRvd24oKCkgPT4ge1xuXHRcdFx0ZG9tLnJlbW92ZUV2ZW50TGlzdGVuZXIoZXZlbnRfbmFtZSwgdGFyZ2V0X2hhbmRsZXIsIG9wdGlvbnMpO1xuXHRcdH0pO1xuXHR9XG59XG5cbi8qKlxuICogQHBhcmFtIHtBcnJheTxzdHJpbmc+fSBldmVudHNcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZGVsZWdhdGUoZXZlbnRzKSB7XG5cdGZvciAodmFyIGkgPSAwOyBpIDwgZXZlbnRzLmxlbmd0aDsgaSsrKSB7XG5cdFx0YWxsX3JlZ2lzdGVyZWRfZXZlbnRzLmFkZChldmVudHNbaV0pO1xuXHR9XG5cblx0Zm9yICh2YXIgZm4gb2Ygcm9vdF9ldmVudF9oYW5kbGVzKSB7XG5cdFx0Zm4oZXZlbnRzKTtcblx0fVxufVxuXG4vKipcbiAqIEB0aGlzIHtFdmVudFRhcmdldH1cbiAqIEBwYXJhbSB7RXZlbnR9IGV2ZW50XG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGhhbmRsZV9ldmVudF9wcm9wYWdhdGlvbihldmVudCkge1xuXHR2YXIgaGFuZGxlcl9lbGVtZW50ID0gdGhpcztcblx0dmFyIG93bmVyX2RvY3VtZW50ID0gLyoqIEB0eXBlIHtOb2RlfSAqLyAoaGFuZGxlcl9lbGVtZW50KS5vd25lckRvY3VtZW50O1xuXHR2YXIgZXZlbnRfbmFtZSA9IGV2ZW50LnR5cGU7XG5cdHZhciBwYXRoID0gZXZlbnQuY29tcG9zZWRQYXRoPy4oKSB8fCBbXTtcblx0dmFyIGN1cnJlbnRfdGFyZ2V0ID0gLyoqIEB0eXBlIHtudWxsIHwgRWxlbWVudH0gKi8gKHBhdGhbMF0gfHwgZXZlbnQudGFyZ2V0KTtcblxuXHQvLyBjb21wb3NlZFBhdGggY29udGFpbnMgbGlzdCBvZiBub2RlcyB0aGUgZXZlbnQgaGFzIHByb3BhZ2F0ZWQgdGhyb3VnaC5cblx0Ly8gV2UgY2hlY2sgX19yb290IHRvIHNraXAgYWxsIG5vZGVzIGJlbG93IGl0IGluIGNhc2UgdGhpcyBpcyBhXG5cdC8vIHBhcmVudCBvZiB0aGUgX19yb290IG5vZGUsIHdoaWNoIGluZGljYXRlcyB0aGF0IHRoZXJlJ3MgbmVzdGVkXG5cdC8vIG1vdW50ZWQgYXBwcy4gSW4gdGhpcyBjYXNlIHdlIGRvbid0IHdhbnQgdG8gdHJpZ2dlciBldmVudHMgbXVsdGlwbGUgdGltZXMuXG5cdHZhciBwYXRoX2lkeCA9IDA7XG5cblx0Ly8gQHRzLWV4cGVjdC1lcnJvciBpcyBhZGRlZCBiZWxvd1xuXHR2YXIgaGFuZGxlZF9hdCA9IGV2ZW50Ll9fcm9vdDtcblxuXHRpZiAoaGFuZGxlZF9hdCkge1xuXHRcdHZhciBhdF9pZHggPSBwYXRoLmluZGV4T2YoaGFuZGxlZF9hdCk7XG5cdFx0aWYgKFxuXHRcdFx0YXRfaWR4ICE9PSAtMSAmJlxuXHRcdFx0KGhhbmRsZXJfZWxlbWVudCA9PT0gZG9jdW1lbnQgfHwgaGFuZGxlcl9lbGVtZW50ID09PSAvKiogQHR5cGUge2FueX0gKi8gKHdpbmRvdykpXG5cdFx0KSB7XG5cdFx0XHQvLyBUaGlzIGlzIHRoZSBmYWxsYmFjayBkb2N1bWVudCBsaXN0ZW5lciBvciBhIHdpbmRvdyBsaXN0ZW5lciwgYnV0IHRoZSBldmVudCB3YXMgYWxyZWFkeSBoYW5kbGVkXG5cdFx0XHQvLyAtPiBpZ25vcmUsIGJ1dCBzZXQgaGFuZGxlX2F0IHRvIGRvY3VtZW50L3dpbmRvdyBzbyB0aGF0IHdlJ3JlIHJlc2V0dGluZyB0aGUgZXZlbnRcblx0XHRcdC8vIGNoYWluIGluIGNhc2Ugc29tZW9uZSBtYW51YWxseSBkaXNwYXRjaGVzIHRoZSBzYW1lIGV2ZW50IG9iamVjdCBhZ2Fpbi5cblx0XHRcdC8vIEB0cy1leHBlY3QtZXJyb3Jcblx0XHRcdGV2ZW50Ll9fcm9vdCA9IGhhbmRsZXJfZWxlbWVudDtcblx0XHRcdHJldHVybjtcblx0XHR9XG5cblx0XHQvLyBXZSdyZSBkZWxpYmVyYXRlbHkgbm90IHNraXBwaW5nIGlmIHRoZSBpbmRleCBpcyBoaWdoZXIsIGJlY2F1c2Vcblx0XHQvLyBzb21lb25lIGNvdWxkIGNyZWF0ZSBhbiBldmVudCBwcm9ncmFtbWF0aWNhbGx5IGFuZCBlbWl0IGl0IG11bHRpcGxlIHRpbWVzLFxuXHRcdC8vIGluIHdoaWNoIGNhc2Ugd2Ugd2FudCB0byBoYW5kbGUgdGhlIHdob2xlIHByb3BhZ2F0aW9uIGNoYWluIHByb3Blcmx5IGVhY2ggdGltZS5cblx0XHQvLyAodGhpcyB3aWxsIG9ubHkgYmUgYSBmYWxzZSBuZWdhdGl2ZSBpZiB0aGUgZXZlbnQgaXMgZGlzcGF0Y2hlZCBtdWx0aXBsZSB0aW1lcyBhbmRcblx0XHQvLyB0aGUgZmFsbGJhY2sgZG9jdW1lbnQgbGlzdGVuZXIgaXNuJ3QgcmVhY2hlZCBpbiBiZXR3ZWVuLCBidXQgdGhhdCdzIHN1cGVyIHJhcmUpXG5cdFx0dmFyIGhhbmRsZXJfaWR4ID0gcGF0aC5pbmRleE9mKGhhbmRsZXJfZWxlbWVudCk7XG5cdFx0aWYgKGhhbmRsZXJfaWR4ID09PSAtMSkge1xuXHRcdFx0Ly8gaGFuZGxlX2lkeCBjYW4gdGhlb3JldGljYWxseSBiZSAtMSAoaGFwcGVuZWQgaW4gc29tZSBKU0RPTSB0ZXN0aW5nIHNjZW5hcmlvcyB3aXRoIGFuIGV2ZW50IGxpc3RlbmVyIG9uIHRoZSB3aW5kb3cgb2JqZWN0KVxuXHRcdFx0Ly8gc28gZ3VhcmQgYWdhaW5zdCB0aGF0LCB0b28sIGFuZCBhc3N1bWUgdGhhdCBldmVyeXRoaW5nIHdhcyBoYW5kbGVkIGF0IHRoaXMgcG9pbnQuXG5cdFx0XHRyZXR1cm47XG5cdFx0fVxuXG5cdFx0aWYgKGF0X2lkeCA8PSBoYW5kbGVyX2lkeCkge1xuXHRcdFx0cGF0aF9pZHggPSBhdF9pZHg7XG5cdFx0fVxuXHR9XG5cblx0Y3VycmVudF90YXJnZXQgPSAvKiogQHR5cGUge0VsZW1lbnR9ICovIChwYXRoW3BhdGhfaWR4XSB8fCBldmVudC50YXJnZXQpO1xuXHQvLyB0aGVyZSBjYW4gb25seSBiZSBvbmUgZGVsZWdhdGVkIGV2ZW50IHBlciBlbGVtZW50LCBhbmQgd2UgZWl0aGVyIGFscmVhZHkgaGFuZGxlZCB0aGUgY3VycmVudCB0YXJnZXQsXG5cdC8vIG9yIHRoaXMgaXMgdGhlIHZlcnkgZmlyc3QgdGFyZ2V0IGluIHRoZSBjaGFpbiB3aGljaCBoYXMgYSBub24tZGVsZWdhdGVkIGxpc3RlbmVyLCBpbiB3aGljaCBjYXNlIGl0J3Mgc2FmZVxuXHQvLyB0byBoYW5kbGUgYSBwb3NzaWJsZSBkZWxlZ2F0ZWQgZXZlbnQgb24gaXQgbGF0ZXIgKHRocm91Z2ggdGhlIHJvb3QgZGVsZWdhdGlvbiBsaXN0ZW5lciBmb3IgZXhhbXBsZSkuXG5cdGlmIChjdXJyZW50X3RhcmdldCA9PT0gaGFuZGxlcl9lbGVtZW50KSByZXR1cm47XG5cblx0Ly8gUHJveHkgY3VycmVudFRhcmdldCB0byBjb3JyZWN0IHRhcmdldFxuXHRkZWZpbmVfcHJvcGVydHkoZXZlbnQsICdjdXJyZW50VGFyZ2V0Jywge1xuXHRcdGNvbmZpZ3VyYWJsZTogdHJ1ZSxcblx0XHRnZXQoKSB7XG5cdFx0XHRyZXR1cm4gY3VycmVudF90YXJnZXQgfHwgb3duZXJfZG9jdW1lbnQ7XG5cdFx0fVxuXHR9KTtcblxuXHQvLyBUaGlzIHN0YXJ0ZWQgYmVjYXVzZSBvZiBDaHJvbWl1bSBpc3N1ZSBodHRwczovL2Nocm9tZXN0YXR1cy5jb20vZmVhdHVyZS81MTI4Njk2ODIzNTQ1ODU2LFxuXHQvLyB3aGVyZSByZW1vdmFsIG9yIG1vdmluZyBvZiBvZiB0aGUgRE9NIGNhbiBjYXVzZSBzeW5jIGBibHVyYCBldmVudHMgdG8gZmlyZSwgd2hpY2ggY2FuIGNhdXNlIGxvZ2ljXG5cdC8vIHRvIHJ1biBpbnNpZGUgdGhlIGN1cnJlbnQgYGFjdGl2ZV9yZWFjdGlvbmAsIHdoaWNoIGlzbid0IHdoYXQgd2Ugd2FudCBhdCBhbGwuIEhvd2V2ZXIsIG9uIHJlZmxlY3Rpb24sXG5cdC8vIGl0J3MgcHJvYmFibHkgYmVzdCB0aGF0IGFsbCBldmVudCBoYW5kbGVkIGJ5IFN2ZWx0ZSBoYXZlIHRoaXMgYmVoYXZpb3VyLCBhcyB3ZSBkb24ndCByZWFsbHkgd2FudFxuXHQvLyBhbiBldmVudCBoYW5kbGVyIHRvIHJ1biBpbiB0aGUgY29udGV4dCBvZiBhbm90aGVyIHJlYWN0aW9uIG9yIGVmZmVjdC5cblx0dmFyIHByZXZpb3VzX3JlYWN0aW9uID0gYWN0aXZlX3JlYWN0aW9uO1xuXHR2YXIgcHJldmlvdXNfZWZmZWN0ID0gYWN0aXZlX2VmZmVjdDtcblx0c2V0X2FjdGl2ZV9yZWFjdGlvbihudWxsKTtcblx0c2V0X2FjdGl2ZV9lZmZlY3QobnVsbCk7XG5cblx0dHJ5IHtcblx0XHQvKipcblx0XHQgKiBAdHlwZSB7dW5rbm93bn1cblx0XHQgKi9cblx0XHR2YXIgdGhyb3dfZXJyb3I7XG5cdFx0LyoqXG5cdFx0ICogQHR5cGUge3Vua25vd25bXX1cblx0XHQgKi9cblx0XHR2YXIgb3RoZXJfZXJyb3JzID0gW107XG5cblx0XHR3aGlsZSAoY3VycmVudF90YXJnZXQgIT09IG51bGwpIHtcblx0XHRcdC8qKiBAdHlwZSB7bnVsbCB8IEVsZW1lbnR9ICovXG5cdFx0XHR2YXIgcGFyZW50X2VsZW1lbnQgPVxuXHRcdFx0XHRjdXJyZW50X3RhcmdldC5hc3NpZ25lZFNsb3QgfHxcblx0XHRcdFx0Y3VycmVudF90YXJnZXQucGFyZW50Tm9kZSB8fFxuXHRcdFx0XHQvKiogQHR5cGUge2FueX0gKi8gKGN1cnJlbnRfdGFyZ2V0KS5ob3N0IHx8XG5cdFx0XHRcdG51bGw7XG5cblx0XHRcdHRyeSB7XG5cdFx0XHRcdC8vIEB0cy1leHBlY3QtZXJyb3Jcblx0XHRcdFx0dmFyIGRlbGVnYXRlZCA9IGN1cnJlbnRfdGFyZ2V0WydfXycgKyBldmVudF9uYW1lXTtcblxuXHRcdFx0XHRpZiAoZGVsZWdhdGVkICE9PSB1bmRlZmluZWQgJiYgISgvKiogQHR5cGUge2FueX0gKi8gKGN1cnJlbnRfdGFyZ2V0KS5kaXNhYmxlZCkpIHtcblx0XHRcdFx0XHRpZiAoaXNfYXJyYXkoZGVsZWdhdGVkKSkge1xuXHRcdFx0XHRcdFx0dmFyIFtmbiwgLi4uZGF0YV0gPSBkZWxlZ2F0ZWQ7XG5cdFx0XHRcdFx0XHRmbi5hcHBseShjdXJyZW50X3RhcmdldCwgW2V2ZW50LCAuLi5kYXRhXSk7XG5cdFx0XHRcdFx0fSBlbHNlIHtcblx0XHRcdFx0XHRcdGRlbGVnYXRlZC5jYWxsKGN1cnJlbnRfdGFyZ2V0LCBldmVudCk7XG5cdFx0XHRcdFx0fVxuXHRcdFx0XHR9XG5cdFx0XHR9IGNhdGNoIChlcnJvcikge1xuXHRcdFx0XHRpZiAodGhyb3dfZXJyb3IpIHtcblx0XHRcdFx0XHRvdGhlcl9lcnJvcnMucHVzaChlcnJvcik7XG5cdFx0XHRcdH0gZWxzZSB7XG5cdFx0XHRcdFx0dGhyb3dfZXJyb3IgPSBlcnJvcjtcblx0XHRcdFx0fVxuXHRcdFx0fVxuXHRcdFx0aWYgKGV2ZW50LmNhbmNlbEJ1YmJsZSB8fCBwYXJlbnRfZWxlbWVudCA9PT0gaGFuZGxlcl9lbGVtZW50IHx8IHBhcmVudF9lbGVtZW50ID09PSBudWxsKSB7XG5cdFx0XHRcdGJyZWFrO1xuXHRcdFx0fVxuXHRcdFx0Y3VycmVudF90YXJnZXQgPSBwYXJlbnRfZWxlbWVudDtcblx0XHR9XG5cblx0XHRpZiAodGhyb3dfZXJyb3IpIHtcblx0XHRcdGZvciAobGV0IGVycm9yIG9mIG90aGVyX2Vycm9ycykge1xuXHRcdFx0XHQvLyBUaHJvdyB0aGUgcmVzdCBvZiB0aGUgZXJyb3JzLCBvbmUtYnktb25lIG9uIGEgbWljcm90YXNrXG5cdFx0XHRcdHF1ZXVlTWljcm90YXNrKCgpID0+IHtcblx0XHRcdFx0XHR0aHJvdyBlcnJvcjtcblx0XHRcdFx0fSk7XG5cdFx0XHR9XG5cdFx0XHR0aHJvdyB0aHJvd19lcnJvcjtcblx0XHR9XG5cdH0gZmluYWxseSB7XG5cdFx0Ly8gQHRzLWV4cGVjdC1lcnJvciBpcyB1c2VkIGFib3ZlXG5cdFx0ZXZlbnQuX19yb290ID0gaGFuZGxlcl9lbGVtZW50O1xuXHRcdC8vIEB0cy1pZ25vcmUgcmVtb3ZlIHByb3h5IG9uIGN1cnJlbnRUYXJnZXRcblx0XHRkZWxldGUgZXZlbnQuY3VycmVudFRhcmdldDtcblx0XHRzZXRfYWN0aXZlX3JlYWN0aW9uKHByZXZpb3VzX3JlYWN0aW9uKTtcblx0XHRzZXRfYWN0aXZlX2VmZmVjdChwcmV2aW91c19lZmZlY3QpO1xuXHR9XG59XG5cbi8qKlxuICogSW4gZGV2LCB3YXJuIGlmIGFuIGV2ZW50IGhhbmRsZXIgaXMgbm90IGEgZnVuY3Rpb24sIGFzIGl0IG1lYW5zIHRoZVxuICogdXNlciBwcm9iYWJseSBjYWxsZWQgdGhlIGhhbmRsZXIgb3IgZm9yZ290IHRvIGFkZCBhIGAoKSA9PmBcbiAqIEBwYXJhbSB7KCkgPT4gKGV2ZW50OiBFdmVudCwgLi4uYXJnczogYW55KSA9PiB2b2lkfSB0aHVua1xuICogQHBhcmFtIHtFdmVudFRhcmdldH0gZWxlbWVudFxuICogQHBhcmFtIHtbRXZlbnQsIC4uLmFueV19IGFyZ3NcbiAqIEBwYXJhbSB7YW55fSBjb21wb25lbnRcbiAqIEBwYXJhbSB7W251bWJlciwgbnVtYmVyXX0gW2xvY11cbiAqIEBwYXJhbSB7Ym9vbGVhbn0gW3JlbW92ZV9wYXJlbnNdXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBhcHBseShcblx0dGh1bmssXG5cdGVsZW1lbnQsXG5cdGFyZ3MsXG5cdGNvbXBvbmVudCxcblx0bG9jLFxuXHRoYXNfc2lkZV9lZmZlY3RzID0gZmFsc2UsXG5cdHJlbW92ZV9wYXJlbnMgPSBmYWxzZVxuKSB7XG5cdGxldCBoYW5kbGVyO1xuXHRsZXQgZXJyb3I7XG5cblx0dHJ5IHtcblx0XHRoYW5kbGVyID0gdGh1bmsoKTtcblx0fSBjYXRjaCAoZSkge1xuXHRcdGVycm9yID0gZTtcblx0fVxuXG5cdGlmICh0eXBlb2YgaGFuZGxlciA9PT0gJ2Z1bmN0aW9uJykge1xuXHRcdGhhbmRsZXIuYXBwbHkoZWxlbWVudCwgYXJncyk7XG5cdH0gZWxzZSBpZiAoaGFzX3NpZGVfZWZmZWN0cyB8fCBoYW5kbGVyICE9IG51bGwgfHwgZXJyb3IpIHtcblx0XHRjb25zdCBmaWxlbmFtZSA9IGNvbXBvbmVudD8uW0ZJTEVOQU1FXTtcblx0XHRjb25zdCBsb2NhdGlvbiA9IGxvYyA/IGAgYXQgJHtmaWxlbmFtZX06JHtsb2NbMF19OiR7bG9jWzFdfWAgOiBgIGluICR7ZmlsZW5hbWV9YDtcblxuXHRcdGNvbnN0IGV2ZW50X25hbWUgPSBhcmdzWzBdLnR5cGU7XG5cdFx0Y29uc3QgZGVzY3JpcHRpb24gPSBgXFxgJHtldmVudF9uYW1lfVxcYCBoYW5kbGVyJHtsb2NhdGlvbn1gO1xuXHRcdGNvbnN0IHN1Z2dlc3Rpb24gPSByZW1vdmVfcGFyZW5zID8gJ3JlbW92ZSB0aGUgdHJhaWxpbmcgYCgpYCcgOiAnYWRkIGEgbGVhZGluZyBgKCkgPT5gJztcblxuXHRcdHcuZXZlbnRfaGFuZGxlcl9pbnZhbGlkKGRlc2NyaXB0aW9uLCBzdWdnZXN0aW9uKTtcblxuXHRcdGlmIChlcnJvcikge1xuXHRcdFx0dGhyb3cgZXJyb3I7XG5cdFx0fVxuXHR9XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBUZW1wbGF0ZU5vZGUgfSBmcm9tICcjY2xpZW50JyAqL1xuaW1wb3J0IHsgaHlkcmF0ZV9ub2RlLCBoeWRyYXRpbmcsIHNldF9oeWRyYXRlX25vZGUsIHNldF9oeWRyYXRpbmcgfSBmcm9tICcuLi9oeWRyYXRpb24uanMnO1xuaW1wb3J0IHsgY3JlYXRlX3RleHQsIGdldF9maXJzdF9jaGlsZCwgZ2V0X25leHRfc2libGluZyB9IGZyb20gJy4uL29wZXJhdGlvbnMuanMnO1xuaW1wb3J0IHsgYmxvY2sgfSBmcm9tICcuLi8uLi9yZWFjdGl2aXR5L2VmZmVjdHMuanMnO1xuaW1wb3J0IHsgSEVBRF9FRkZFQ1QgfSBmcm9tICcuLi8uLi9jb25zdGFudHMuanMnO1xuaW1wb3J0IHsgSFlEUkFUSU9OX1NUQVJUIH0gZnJvbSAnLi4vLi4vLi4vLi4vY29uc3RhbnRzLmpzJztcblxuLyoqXG4gKiBAdHlwZSB7Tm9kZSB8IHVuZGVmaW5lZH1cbiAqL1xubGV0IGhlYWRfYW5jaG9yO1xuXG5leHBvcnQgZnVuY3Rpb24gcmVzZXRfaGVhZF9hbmNob3IoKSB7XG5cdGhlYWRfYW5jaG9yID0gdW5kZWZpbmVkO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7KGFuY2hvcjogTm9kZSkgPT4gdm9pZH0gcmVuZGVyX2ZuXG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGhlYWQocmVuZGVyX2ZuKSB7XG5cdC8vIFRoZSBoZWFkIGZ1bmN0aW9uIG1heSBiZSBjYWxsZWQgYWZ0ZXIgdGhlIGZpcnN0IGh5ZHJhdGlvbiBwYXNzIGFuZCBzc3IgY29tbWVudCBub2RlcyBtYXkgc3RpbGwgYmUgcHJlc2VudCxcblx0Ly8gdGhlcmVmb3JlIHdlIG5lZWQgdG8gc2tpcCB0aGF0IHdoZW4gd2UgZGV0ZWN0IHRoYXQgd2UncmUgbm90IGluIGh5ZHJhdGlvbiBtb2RlLlxuXHRsZXQgcHJldmlvdXNfaHlkcmF0ZV9ub2RlID0gbnVsbDtcblx0bGV0IHdhc19oeWRyYXRpbmcgPSBoeWRyYXRpbmc7XG5cblx0LyoqIEB0eXBlIHtDb21tZW50IHwgVGV4dH0gKi9cblx0dmFyIGFuY2hvcjtcblxuXHRpZiAoaHlkcmF0aW5nKSB7XG5cdFx0cHJldmlvdXNfaHlkcmF0ZV9ub2RlID0gaHlkcmF0ZV9ub2RlO1xuXG5cdFx0Ly8gVGhlcmUgbWlnaHQgYmUgbXVsdGlwbGUgaGVhZCBibG9ja3MgaW4gb3VyIGFwcCwgc28gd2UgbmVlZCB0byBhY2NvdW50IGZvciBlYWNoIG9uZSBuZWVkaW5nIGluZGVwZW5kZW50IGh5ZHJhdGlvbi5cblx0XHRpZiAoaGVhZF9hbmNob3IgPT09IHVuZGVmaW5lZCkge1xuXHRcdFx0aGVhZF9hbmNob3IgPSAvKiogQHR5cGUge1RlbXBsYXRlTm9kZX0gKi8gKGdldF9maXJzdF9jaGlsZChkb2N1bWVudC5oZWFkKSk7XG5cdFx0fVxuXG5cdFx0d2hpbGUgKFxuXHRcdFx0aGVhZF9hbmNob3IgIT09IG51bGwgJiZcblx0XHRcdChoZWFkX2FuY2hvci5ub2RlVHlwZSAhPT0gOCB8fCAvKiogQHR5cGUge0NvbW1lbnR9ICovIChoZWFkX2FuY2hvcikuZGF0YSAhPT0gSFlEUkFUSU9OX1NUQVJUKVxuXHRcdCkge1xuXHRcdFx0aGVhZF9hbmNob3IgPSAvKiogQHR5cGUge1RlbXBsYXRlTm9kZX0gKi8gKGdldF9uZXh0X3NpYmxpbmcoaGVhZF9hbmNob3IpKTtcblx0XHR9XG5cblx0XHQvLyBJZiB3ZSBjYW4ndCBmaW5kIGFuIG9wZW5pbmcgaHlkcmF0aW9uIG1hcmtlciwgc2tpcCBoeWRyYXRpb24gKHRoaXMgY2FuIGhhcHBlblxuXHRcdC8vIGlmIGEgZnJhbWV3b3JrIHJlbmRlcmVkIGJvZHkgYnV0IG5vdCBoZWFkIGNvbnRlbnQpXG5cdFx0aWYgKGhlYWRfYW5jaG9yID09PSBudWxsKSB7XG5cdFx0XHRzZXRfaHlkcmF0aW5nKGZhbHNlKTtcblx0XHR9IGVsc2Uge1xuXHRcdFx0aGVhZF9hbmNob3IgPSBzZXRfaHlkcmF0ZV9ub2RlKC8qKiBAdHlwZSB7VGVtcGxhdGVOb2RlfSAqLyAoZ2V0X25leHRfc2libGluZyhoZWFkX2FuY2hvcikpKTtcblx0XHR9XG5cdH1cblxuXHRpZiAoIWh5ZHJhdGluZykge1xuXHRcdGFuY2hvciA9IGRvY3VtZW50LmhlYWQuYXBwZW5kQ2hpbGQoY3JlYXRlX3RleHQoKSk7XG5cdH1cblxuXHR0cnkge1xuXHRcdGJsb2NrKCgpID0+IHJlbmRlcl9mbihhbmNob3IpLCBIRUFEX0VGRkVDVCk7XG5cdH0gZmluYWxseSB7XG5cdFx0aWYgKHdhc19oeWRyYXRpbmcpIHtcblx0XHRcdHNldF9oeWRyYXRpbmcodHJ1ZSk7XG5cdFx0XHRoZWFkX2FuY2hvciA9IGh5ZHJhdGVfbm9kZTsgLy8gc28gdGhhdCBuZXh0IGhlYWQgYmxvY2sgc3RhcnRzIGZyb20gdGhlIGNvcnJlY3Qgbm9kZVxuXHRcdFx0c2V0X2h5ZHJhdGVfbm9kZSgvKiogQHR5cGUge1RlbXBsYXRlTm9kZX0gKi8gKHByZXZpb3VzX2h5ZHJhdGVfbm9kZSkpO1xuXHRcdH1cblx0fVxufVxuIiwgIi8qKiBAaW1wb3J0IHsgRWZmZWN0LCBUZW1wbGF0ZU5vZGUgfSBmcm9tICcjY2xpZW50JyAqL1xuaW1wb3J0IHsgaHlkcmF0ZV9uZXh0LCBoeWRyYXRlX25vZGUsIGh5ZHJhdGluZywgc2V0X2h5ZHJhdGVfbm9kZSB9IGZyb20gJy4vaHlkcmF0aW9uLmpzJztcbmltcG9ydCB7IGNyZWF0ZV90ZXh0LCBnZXRfZmlyc3RfY2hpbGQsIGlzX2ZpcmVmb3ggfSBmcm9tICcuL29wZXJhdGlvbnMuanMnO1xuaW1wb3J0IHsgY3JlYXRlX2ZyYWdtZW50X2Zyb21faHRtbCB9IGZyb20gJy4vcmVjb25jaWxlci5qcyc7XG5pbXBvcnQgeyBhY3RpdmVfZWZmZWN0IH0gZnJvbSAnLi4vcnVudGltZS5qcyc7XG5pbXBvcnQgeyBURU1QTEFURV9GUkFHTUVOVCwgVEVNUExBVEVfVVNFX0lNUE9SVF9OT0RFIH0gZnJvbSAnLi4vLi4vLi4vY29uc3RhbnRzLmpzJztcblxuLyoqXG4gKiBAcGFyYW0ge1RlbXBsYXRlTm9kZX0gc3RhcnRcbiAqIEBwYXJhbSB7VGVtcGxhdGVOb2RlIHwgbnVsbH0gZW5kXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBhc3NpZ25fbm9kZXMoc3RhcnQsIGVuZCkge1xuXHR2YXIgZWZmZWN0ID0gLyoqIEB0eXBlIHtFZmZlY3R9ICovIChhY3RpdmVfZWZmZWN0KTtcblx0aWYgKGVmZmVjdC5ub2Rlc19zdGFydCA9PT0gbnVsbCkge1xuXHRcdGVmZmVjdC5ub2Rlc19zdGFydCA9IHN0YXJ0O1xuXHRcdGVmZmVjdC5ub2Rlc19lbmQgPSBlbmQ7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge3N0cmluZ30gY29udGVudFxuICogQHBhcmFtIHtudW1iZXJ9IGZsYWdzXG4gKiBAcmV0dXJucyB7KCkgPT4gTm9kZSB8IE5vZGVbXX1cbiAqL1xuLyojX19OT19TSURFX0VGRkVDVFNfXyovXG5leHBvcnQgZnVuY3Rpb24gdGVtcGxhdGUoY29udGVudCwgZmxhZ3MpIHtcblx0dmFyIGlzX2ZyYWdtZW50ID0gKGZsYWdzICYgVEVNUExBVEVfRlJBR01FTlQpICE9PSAwO1xuXHR2YXIgdXNlX2ltcG9ydF9ub2RlID0gKGZsYWdzICYgVEVNUExBVEVfVVNFX0lNUE9SVF9OT0RFKSAhPT0gMDtcblxuXHQvKiogQHR5cGUge05vZGV9ICovXG5cdHZhciBub2RlO1xuXG5cdC8qKlxuXHQgKiBXaGV0aGVyIG9yIG5vdCB0aGUgZmlyc3QgaXRlbSBpcyBhIHRleHQvZWxlbWVudCBub2RlLiBJZiBub3QsIHdlIG5lZWQgdG9cblx0ICogY3JlYXRlIGFuIGFkZGl0aW9uYWwgY29tbWVudCBub2RlIHRvIGFjdCBhcyBgZWZmZWN0Lm5vZGVzLnN0YXJ0YFxuXHQgKi9cblx0dmFyIGhhc19zdGFydCA9ICFjb250ZW50LnN0YXJ0c1dpdGgoJzwhPicpO1xuXG5cdHJldHVybiAoKSA9PiB7XG5cdFx0aWYgKGh5ZHJhdGluZykge1xuXHRcdFx0YXNzaWduX25vZGVzKGh5ZHJhdGVfbm9kZSwgbnVsbCk7XG5cdFx0XHRyZXR1cm4gaHlkcmF0ZV9ub2RlO1xuXHRcdH1cblxuXHRcdGlmIChub2RlID09PSB1bmRlZmluZWQpIHtcblx0XHRcdG5vZGUgPSBjcmVhdGVfZnJhZ21lbnRfZnJvbV9odG1sKGhhc19zdGFydCA/IGNvbnRlbnQgOiAnPCE+JyArIGNvbnRlbnQpO1xuXHRcdFx0aWYgKCFpc19mcmFnbWVudCkgbm9kZSA9IC8qKiBAdHlwZSB7Tm9kZX0gKi8gKGdldF9maXJzdF9jaGlsZChub2RlKSk7XG5cdFx0fVxuXG5cdFx0dmFyIGNsb25lID0gLyoqIEB0eXBlIHtUZW1wbGF0ZU5vZGV9ICovIChcblx0XHRcdHVzZV9pbXBvcnRfbm9kZSB8fCBpc19maXJlZm94ID8gZG9jdW1lbnQuaW1wb3J0Tm9kZShub2RlLCB0cnVlKSA6IG5vZGUuY2xvbmVOb2RlKHRydWUpXG5cdFx0KTtcblxuXHRcdGlmIChpc19mcmFnbWVudCkge1xuXHRcdFx0dmFyIHN0YXJ0ID0gLyoqIEB0eXBlIHtUZW1wbGF0ZU5vZGV9ICovIChnZXRfZmlyc3RfY2hpbGQoY2xvbmUpKTtcblx0XHRcdHZhciBlbmQgPSAvKiogQHR5cGUge1RlbXBsYXRlTm9kZX0gKi8gKGNsb25lLmxhc3RDaGlsZCk7XG5cblx0XHRcdGFzc2lnbl9ub2RlcyhzdGFydCwgZW5kKTtcblx0XHR9IGVsc2Uge1xuXHRcdFx0YXNzaWduX25vZGVzKGNsb25lLCBjbG9uZSk7XG5cdFx0fVxuXG5cdFx0cmV0dXJuIGNsb25lO1xuXHR9O1xufVxuXG4vKipcbiAqIEBwYXJhbSB7c3RyaW5nfSBjb250ZW50XG4gKiBAcGFyYW0ge251bWJlcn0gZmxhZ3NcbiAqIEByZXR1cm5zIHsoKSA9PiBOb2RlIHwgTm9kZVtdfVxuICovXG4vKiNfX05PX1NJREVfRUZGRUNUU19fKi9cbmV4cG9ydCBmdW5jdGlvbiB0ZW1wbGF0ZV93aXRoX3NjcmlwdChjb250ZW50LCBmbGFncykge1xuXHR2YXIgZm4gPSB0ZW1wbGF0ZShjb250ZW50LCBmbGFncyk7XG5cdHJldHVybiAoKSA9PiBydW5fc2NyaXB0cygvKiogQHR5cGUge0VsZW1lbnQgfCBEb2N1bWVudEZyYWdtZW50fSAqLyAoZm4oKSkpO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7c3RyaW5nfSBjb250ZW50XG4gKiBAcGFyYW0ge251bWJlcn0gZmxhZ3NcbiAqIEBwYXJhbSB7J3N2ZycgfCAnbWF0aCd9IG5zXG4gKiBAcmV0dXJucyB7KCkgPT4gTm9kZSB8IE5vZGVbXX1cbiAqL1xuLyojX19OT19TSURFX0VGRkVDVFNfXyovXG5leHBvcnQgZnVuY3Rpb24gbnNfdGVtcGxhdGUoY29udGVudCwgZmxhZ3MsIG5zID0gJ3N2ZycpIHtcblx0LyoqXG5cdCAqIFdoZXRoZXIgb3Igbm90IHRoZSBmaXJzdCBpdGVtIGlzIGEgdGV4dC9lbGVtZW50IG5vZGUuIElmIG5vdCwgd2UgbmVlZCB0b1xuXHQgKiBjcmVhdGUgYW4gYWRkaXRpb25hbCBjb21tZW50IG5vZGUgdG8gYWN0IGFzIGBlZmZlY3Qubm9kZXMuc3RhcnRgXG5cdCAqL1xuXHR2YXIgaGFzX3N0YXJ0ID0gIWNvbnRlbnQuc3RhcnRzV2l0aCgnPCE+Jyk7XG5cblx0dmFyIGlzX2ZyYWdtZW50ID0gKGZsYWdzICYgVEVNUExBVEVfRlJBR01FTlQpICE9PSAwO1xuXHR2YXIgd3JhcHBlZCA9IGA8JHtuc30+JHtoYXNfc3RhcnQgPyBjb250ZW50IDogJzwhPicgKyBjb250ZW50fTwvJHtuc30+YDtcblxuXHQvKiogQHR5cGUge0VsZW1lbnQgfCBEb2N1bWVudEZyYWdtZW50fSAqL1xuXHR2YXIgbm9kZTtcblxuXHRyZXR1cm4gKCkgPT4ge1xuXHRcdGlmIChoeWRyYXRpbmcpIHtcblx0XHRcdGFzc2lnbl9ub2RlcyhoeWRyYXRlX25vZGUsIG51bGwpO1xuXHRcdFx0cmV0dXJuIGh5ZHJhdGVfbm9kZTtcblx0XHR9XG5cblx0XHRpZiAoIW5vZGUpIHtcblx0XHRcdHZhciBmcmFnbWVudCA9IC8qKiBAdHlwZSB7RG9jdW1lbnRGcmFnbWVudH0gKi8gKGNyZWF0ZV9mcmFnbWVudF9mcm9tX2h0bWwod3JhcHBlZCkpO1xuXHRcdFx0dmFyIHJvb3QgPSAvKiogQHR5cGUge0VsZW1lbnR9ICovIChnZXRfZmlyc3RfY2hpbGQoZnJhZ21lbnQpKTtcblxuXHRcdFx0aWYgKGlzX2ZyYWdtZW50KSB7XG5cdFx0XHRcdG5vZGUgPSBkb2N1bWVudC5jcmVhdGVEb2N1bWVudEZyYWdtZW50KCk7XG5cdFx0XHRcdHdoaWxlIChnZXRfZmlyc3RfY2hpbGQocm9vdCkpIHtcblx0XHRcdFx0XHRub2RlLmFwcGVuZENoaWxkKC8qKiBAdHlwZSB7Tm9kZX0gKi8gKGdldF9maXJzdF9jaGlsZChyb290KSkpO1xuXHRcdFx0XHR9XG5cdFx0XHR9IGVsc2Uge1xuXHRcdFx0XHRub2RlID0gLyoqIEB0eXBlIHtFbGVtZW50fSAqLyAoZ2V0X2ZpcnN0X2NoaWxkKHJvb3QpKTtcblx0XHRcdH1cblx0XHR9XG5cblx0XHR2YXIgY2xvbmUgPSAvKiogQHR5cGUge1RlbXBsYXRlTm9kZX0gKi8gKG5vZGUuY2xvbmVOb2RlKHRydWUpKTtcblxuXHRcdGlmIChpc19mcmFnbWVudCkge1xuXHRcdFx0dmFyIHN0YXJ0ID0gLyoqIEB0eXBlIHtUZW1wbGF0ZU5vZGV9ICovIChnZXRfZmlyc3RfY2hpbGQoY2xvbmUpKTtcblx0XHRcdHZhciBlbmQgPSAvKiogQHR5cGUge1RlbXBsYXRlTm9kZX0gKi8gKGNsb25lLmxhc3RDaGlsZCk7XG5cblx0XHRcdGFzc2lnbl9ub2RlcyhzdGFydCwgZW5kKTtcblx0XHR9IGVsc2Uge1xuXHRcdFx0YXNzaWduX25vZGVzKGNsb25lLCBjbG9uZSk7XG5cdFx0fVxuXG5cdFx0cmV0dXJuIGNsb25lO1xuXHR9O1xufVxuXG4vKipcbiAqIEBwYXJhbSB7c3RyaW5nfSBjb250ZW50XG4gKiBAcGFyYW0ge251bWJlcn0gZmxhZ3NcbiAqIEByZXR1cm5zIHsoKSA9PiBOb2RlIHwgTm9kZVtdfVxuICovXG4vKiNfX05PX1NJREVfRUZGRUNUU19fKi9cbmV4cG9ydCBmdW5jdGlvbiBzdmdfdGVtcGxhdGVfd2l0aF9zY3JpcHQoY29udGVudCwgZmxhZ3MpIHtcblx0dmFyIGZuID0gbnNfdGVtcGxhdGUoY29udGVudCwgZmxhZ3MpO1xuXHRyZXR1cm4gKCkgPT4gcnVuX3NjcmlwdHMoLyoqIEB0eXBlIHtFbGVtZW50IHwgRG9jdW1lbnRGcmFnbWVudH0gKi8gKGZuKCkpKTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge3N0cmluZ30gY29udGVudFxuICogQHBhcmFtIHtudW1iZXJ9IGZsYWdzXG4gKiBAcmV0dXJucyB7KCkgPT4gTm9kZSB8IE5vZGVbXX1cbiAqL1xuLyojX19OT19TSURFX0VGRkVDVFNfXyovXG5leHBvcnQgZnVuY3Rpb24gbWF0aG1sX3RlbXBsYXRlKGNvbnRlbnQsIGZsYWdzKSB7XG5cdHJldHVybiBuc190ZW1wbGF0ZShjb250ZW50LCBmbGFncywgJ21hdGgnKTtcbn1cblxuLyoqXG4gKiBDcmVhdGluZyBhIGRvY3VtZW50IGZyYWdtZW50IGZyb20gSFRNTCB0aGF0IGNvbnRhaW5zIHNjcmlwdCB0YWdzIHdpbGwgbm90IGV4ZWN1dGVcbiAqIHRoZSBzY3JpcHRzLiBXZSBuZWVkIHRvIHJlcGxhY2UgdGhlIHNjcmlwdCB0YWdzIHdpdGggbmV3IG9uZXMgc28gdGhhdCB0aGV5IGFyZSBleGVjdXRlZC5cbiAqIEBwYXJhbSB7RWxlbWVudCB8IERvY3VtZW50RnJhZ21lbnR9IG5vZGVcbiAqIEByZXR1cm5zIHtOb2RlIHwgTm9kZVtdfVxuICovXG5mdW5jdGlvbiBydW5fc2NyaXB0cyhub2RlKSB7XG5cdC8vIHNjcmlwdHMgd2VyZSBTU1InZCwgaW4gd2hpY2ggY2FzZSB0aGV5IHdpbGwgcnVuXG5cdGlmIChoeWRyYXRpbmcpIHJldHVybiBub2RlO1xuXG5cdGNvbnN0IGlzX2ZyYWdtZW50ID0gbm9kZS5ub2RlVHlwZSA9PT0gMTE7XG5cdGNvbnN0IHNjcmlwdHMgPVxuXHRcdC8qKiBAdHlwZSB7SFRNTEVsZW1lbnR9ICovIChub2RlKS50YWdOYW1lID09PSAnU0NSSVBUJ1xuXHRcdFx0PyBbLyoqIEB0eXBlIHtIVE1MU2NyaXB0RWxlbWVudH0gKi8gKG5vZGUpXVxuXHRcdFx0OiBub2RlLnF1ZXJ5U2VsZWN0b3JBbGwoJ3NjcmlwdCcpO1xuXHRjb25zdCBlZmZlY3QgPSAvKiogQHR5cGUge0VmZmVjdH0gKi8gKGFjdGl2ZV9lZmZlY3QpO1xuXG5cdGZvciAoY29uc3Qgc2NyaXB0IG9mIHNjcmlwdHMpIHtcblx0XHRjb25zdCBjbG9uZSA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ3NjcmlwdCcpO1xuXHRcdGZvciAodmFyIGF0dHJpYnV0ZSBvZiBzY3JpcHQuYXR0cmlidXRlcykge1xuXHRcdFx0Y2xvbmUuc2V0QXR0cmlidXRlKGF0dHJpYnV0ZS5uYW1lLCBhdHRyaWJ1dGUudmFsdWUpO1xuXHRcdH1cblxuXHRcdGNsb25lLnRleHRDb250ZW50ID0gc2NyaXB0LnRleHRDb250ZW50O1xuXG5cdFx0Ly8gVGhlIHNjcmlwdCBoYXMgY2hhbmdlZCAtIGlmIGl0J3MgYXQgdGhlIGVkZ2VzLCB0aGUgZWZmZWN0IG5vdyBwb2ludHMgYXQgZGVhZCBub2Rlc1xuXHRcdGlmIChpc19mcmFnbWVudCA/IG5vZGUuZmlyc3RDaGlsZCA9PT0gc2NyaXB0IDogbm9kZSA9PT0gc2NyaXB0KSB7XG5cdFx0XHRlZmZlY3Qubm9kZXNfc3RhcnQgPSBjbG9uZTtcblx0XHR9XG5cdFx0aWYgKGlzX2ZyYWdtZW50ID8gbm9kZS5sYXN0Q2hpbGQgPT09IHNjcmlwdCA6IG5vZGUgPT09IHNjcmlwdCkge1xuXHRcdFx0ZWZmZWN0Lm5vZGVzX2VuZCA9IGNsb25lO1xuXHRcdH1cblxuXHRcdHNjcmlwdC5yZXBsYWNlV2l0aChjbG9uZSk7XG5cdH1cblx0cmV0dXJuIG5vZGU7XG59XG5cbi8qKlxuICogRG9uJ3QgbWFyayB0aGlzIGFzIHNpZGUtZWZmZWN0LWZyZWUsIGh5ZHJhdGlvbiBuZWVkcyB0byB3YWxrIGFsbCBub2Rlc1xuICogQHBhcmFtIHthbnl9IHZhbHVlXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiB0ZXh0KHZhbHVlID0gJycpIHtcblx0aWYgKCFoeWRyYXRpbmcpIHtcblx0XHR2YXIgdCA9IGNyZWF0ZV90ZXh0KHZhbHVlICsgJycpO1xuXHRcdGFzc2lnbl9ub2Rlcyh0LCB0KTtcblx0XHRyZXR1cm4gdDtcblx0fVxuXG5cdHZhciBub2RlID0gaHlkcmF0ZV9ub2RlO1xuXG5cdGlmIChub2RlLm5vZGVUeXBlICE9PSAzKSB7XG5cdFx0Ly8gaWYgYW4ge2V4cHJlc3Npb259IGlzIGVtcHR5IGR1cmluZyBTU1IsIHdlIG5lZWQgdG8gaW5zZXJ0IGFuIGVtcHR5IHRleHQgbm9kZVxuXHRcdG5vZGUuYmVmb3JlKChub2RlID0gY3JlYXRlX3RleHQoKSkpO1xuXHRcdHNldF9oeWRyYXRlX25vZGUobm9kZSk7XG5cdH1cblxuXHRhc3NpZ25fbm9kZXMobm9kZSwgbm9kZSk7XG5cdHJldHVybiBub2RlO1xufVxuXG5leHBvcnQgZnVuY3Rpb24gY29tbWVudCgpIHtcblx0Ly8gd2UncmUgbm90IGRlbGVnYXRpbmcgdG8gYHRlbXBsYXRlYCBoZXJlIGZvciBwZXJmb3JtYW5jZSByZWFzb25zXG5cdGlmIChoeWRyYXRpbmcpIHtcblx0XHRhc3NpZ25fbm9kZXMoaHlkcmF0ZV9ub2RlLCBudWxsKTtcblx0XHRyZXR1cm4gaHlkcmF0ZV9ub2RlO1xuXHR9XG5cblx0dmFyIGZyYWcgPSBkb2N1bWVudC5jcmVhdGVEb2N1bWVudEZyYWdtZW50KCk7XG5cdHZhciBzdGFydCA9IGRvY3VtZW50LmNyZWF0ZUNvbW1lbnQoJycpO1xuXHR2YXIgYW5jaG9yID0gY3JlYXRlX3RleHQoKTtcblx0ZnJhZy5hcHBlbmQoc3RhcnQsIGFuY2hvcik7XG5cblx0YXNzaWduX25vZGVzKHN0YXJ0LCBhbmNob3IpO1xuXG5cdHJldHVybiBmcmFnO1xufVxuXG4vKipcbiAqIEFzc2lnbiB0aGUgY3JlYXRlZCAob3IgaW4gaHlkcmF0aW9uIG1vZGUsIHRyYXZlcnNlZCkgZG9tIGVsZW1lbnRzIHRvIHRoZSBjdXJyZW50IGJsb2NrXG4gKiBhbmQgaW5zZXJ0IHRoZSBlbGVtZW50cyBpbnRvIHRoZSBkb20gKGluIGNsaWVudCBtb2RlKS5cbiAqIEBwYXJhbSB7VGV4dCB8IENvbW1lbnQgfCBFbGVtZW50fSBhbmNob3JcbiAqIEBwYXJhbSB7RG9jdW1lbnRGcmFnbWVudCB8IEVsZW1lbnR9IGRvbVxuICovXG5leHBvcnQgZnVuY3Rpb24gYXBwZW5kKGFuY2hvciwgZG9tKSB7XG5cdGlmIChoeWRyYXRpbmcpIHtcblx0XHQvKiogQHR5cGUge0VmZmVjdH0gKi8gKGFjdGl2ZV9lZmZlY3QpLm5vZGVzX2VuZCA9IGh5ZHJhdGVfbm9kZTtcblx0XHRoeWRyYXRlX25leHQoKTtcblx0XHRyZXR1cm47XG5cdH1cblxuXHRpZiAoYW5jaG9yID09PSBudWxsKSB7XG5cdFx0Ly8gZWRnZSBjYXNlIFx1MjAxNCB2b2lkIGA8c3ZlbHRlOmVsZW1lbnQ+YCB3aXRoIGNvbnRlbnRcblx0XHRyZXR1cm47XG5cdH1cblxuXHRhbmNob3IuYmVmb3JlKC8qKiBAdHlwZSB7Tm9kZX0gKi8gKGRvbSkpO1xufVxuXG5sZXQgdWlkID0gMTtcblxuZXhwb3J0IGZ1bmN0aW9uIHJlc2V0X3Byb3BzX2lkKCkge1xuXHR1aWQgPSAxO1xufVxuXG4vKipcbiAqIENyZWF0ZSAob3IgaHlkcmF0ZSkgYW4gdW5pcXVlIFVJRCBmb3IgdGhlIGNvbXBvbmVudCBpbnN0YW5jZS5cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHByb3BzX2lkKCkge1xuXHRpZiAoXG5cdFx0aHlkcmF0aW5nICYmXG5cdFx0aHlkcmF0ZV9ub2RlICYmXG5cdFx0aHlkcmF0ZV9ub2RlLm5vZGVUeXBlID09PSA4ICYmXG5cdFx0aHlkcmF0ZV9ub2RlLnRleHRDb250ZW50Py5zdGFydHNXaXRoKCcjcycpXG5cdCkge1xuXHRcdGNvbnN0IGlkID0gaHlkcmF0ZV9ub2RlLnRleHRDb250ZW50LnN1YnN0cmluZygxKTtcblx0XHRoeWRyYXRlX25leHQoKTtcblx0XHRyZXR1cm4gaWQ7XG5cdH1cblxuXHRyZXR1cm4gJ2MnICsgdWlkKys7XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBDb21wb25lbnRDb250ZXh0LCBFZmZlY3QsIFRlbXBsYXRlTm9kZSB9IGZyb20gJyNjbGllbnQnICovXG4vKiogQGltcG9ydCB7IENvbXBvbmVudCwgQ29tcG9uZW50VHlwZSwgU3ZlbHRlQ29tcG9uZW50LCBNb3VudE9wdGlvbnMgfSBmcm9tICcuLi8uLi9pbmRleC5qcycgKi9cbmltcG9ydCB7IERFViB9IGZyb20gJ2VzbS1lbnYnO1xuaW1wb3J0IHtcblx0Y2xlYXJfdGV4dF9jb250ZW50LFxuXHRjcmVhdGVfdGV4dCxcblx0Z2V0X2ZpcnN0X2NoaWxkLFxuXHRnZXRfbmV4dF9zaWJsaW5nLFxuXHRpbml0X29wZXJhdGlvbnNcbn0gZnJvbSAnLi9kb20vb3BlcmF0aW9ucy5qcyc7XG5pbXBvcnQgeyBIWURSQVRJT05fRU5ELCBIWURSQVRJT05fRVJST1IsIEhZRFJBVElPTl9TVEFSVCB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy5qcyc7XG5pbXBvcnQgeyBhY3RpdmVfZWZmZWN0IH0gZnJvbSAnLi9ydW50aW1lLmpzJztcbmltcG9ydCB7IHB1c2gsIHBvcCwgY29tcG9uZW50X2NvbnRleHQgfSBmcm9tICcuL2NvbnRleHQuanMnO1xuaW1wb3J0IHsgY29tcG9uZW50X3Jvb3QsIGJyYW5jaCB9IGZyb20gJy4vcmVhY3Rpdml0eS9lZmZlY3RzLmpzJztcbmltcG9ydCB7XG5cdGh5ZHJhdGVfbmV4dCxcblx0aHlkcmF0ZV9ub2RlLFxuXHRoeWRyYXRpbmcsXG5cdHNldF9oeWRyYXRlX25vZGUsXG5cdHNldF9oeWRyYXRpbmdcbn0gZnJvbSAnLi9kb20vaHlkcmF0aW9uLmpzJztcbmltcG9ydCB7IGFycmF5X2Zyb20gfSBmcm9tICcuLi9zaGFyZWQvdXRpbHMuanMnO1xuaW1wb3J0IHtcblx0YWxsX3JlZ2lzdGVyZWRfZXZlbnRzLFxuXHRoYW5kbGVfZXZlbnRfcHJvcGFnYXRpb24sXG5cdHJvb3RfZXZlbnRfaGFuZGxlc1xufSBmcm9tICcuL2RvbS9lbGVtZW50cy9ldmVudHMuanMnO1xuaW1wb3J0IHsgcmVzZXRfaGVhZF9hbmNob3IgfSBmcm9tICcuL2RvbS9ibG9ja3Mvc3ZlbHRlLWhlYWQuanMnO1xuaW1wb3J0ICogYXMgdyBmcm9tICcuL3dhcm5pbmdzLmpzJztcbmltcG9ydCAqIGFzIGUgZnJvbSAnLi9lcnJvcnMuanMnO1xuaW1wb3J0IHsgYXNzaWduX25vZGVzIH0gZnJvbSAnLi9kb20vdGVtcGxhdGUuanMnO1xuaW1wb3J0IHsgaXNfcGFzc2l2ZV9ldmVudCB9IGZyb20gJy4uLy4uL3V0aWxzLmpzJztcblxuLyoqXG4gKiBUaGlzIGlzIG5vcm1hbGx5IHRydWUgXHUyMDE0IGJsb2NrIGVmZmVjdHMgc2hvdWxkIHJ1biB0aGVpciBpbnRybyB0cmFuc2l0aW9ucyBcdTIwMTRcbiAqIGJ1dCBpcyBmYWxzZSBkdXJpbmcgaHlkcmF0aW9uICh1bmxlc3MgYG9wdGlvbnMuaW50cm9gIGlzIGB0cnVlYCkgYW5kXG4gKiB3aGVuIGNyZWF0aW5nIHRoZSBjaGlsZHJlbiBvZiBhIGA8c3ZlbHRlOmVsZW1lbnQ+YCB0aGF0IGp1c3QgY2hhbmdlZCB0YWdcbiAqL1xuZXhwb3J0IGxldCBzaG91bGRfaW50cm8gPSB0cnVlO1xuXG4vKiogQHBhcmFtIHtib29sZWFufSB2YWx1ZSAqL1xuZXhwb3J0IGZ1bmN0aW9uIHNldF9zaG91bGRfaW50cm8odmFsdWUpIHtcblx0c2hvdWxkX2ludHJvID0gdmFsdWU7XG59XG5cbi8qKlxuICogQHBhcmFtIHtFbGVtZW50fSB0ZXh0XG4gKiBAcGFyYW0ge3N0cmluZ30gdmFsdWVcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gc2V0X3RleHQodGV4dCwgdmFsdWUpIHtcblx0Ly8gRm9yIG9iamVjdHMsIHdlIGFwcGx5IHN0cmluZyBjb2VyY2lvbiAod2hpY2ggbWlnaHQgbWFrZSB0aGluZ3MgbGlrZSAkc3RhdGUgYXJyYXkgcmVmZXJlbmNlcyBpbiB0aGUgdGVtcGxhdGUgcmVhY3RpdmUpIGJlZm9yZSBkaWZmaW5nXG5cdHZhciBzdHIgPSB2YWx1ZSA9PSBudWxsID8gJycgOiB0eXBlb2YgdmFsdWUgPT09ICdvYmplY3QnID8gdmFsdWUgKyAnJyA6IHZhbHVlO1xuXHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdGlmIChzdHIgIT09ICh0ZXh0Ll9fdCA/Pz0gdGV4dC5ub2RlVmFsdWUpKSB7XG5cdFx0Ly8gQHRzLWV4cGVjdC1lcnJvclxuXHRcdHRleHQuX190ID0gc3RyO1xuXHRcdHRleHQubm9kZVZhbHVlID0gc3RyICsgJyc7XG5cdH1cbn1cblxuLyoqXG4gKiBNb3VudHMgYSBjb21wb25lbnQgdG8gdGhlIGdpdmVuIHRhcmdldCBhbmQgcmV0dXJucyB0aGUgZXhwb3J0cyBhbmQgcG90ZW50aWFsbHkgdGhlIHByb3BzIChpZiBjb21waWxlZCB3aXRoIGBhY2Nlc3NvcnM6IHRydWVgKSBvZiB0aGUgY29tcG9uZW50LlxuICogVHJhbnNpdGlvbnMgd2lsbCBwbGF5IGR1cmluZyB0aGUgaW5pdGlhbCByZW5kZXIgdW5sZXNzIHRoZSBgaW50cm9gIG9wdGlvbiBpcyBzZXQgdG8gYGZhbHNlYC5cbiAqXG4gKiBAdGVtcGxhdGUge1JlY29yZDxzdHJpbmcsIGFueT59IFByb3BzXG4gKiBAdGVtcGxhdGUge1JlY29yZDxzdHJpbmcsIGFueT59IEV4cG9ydHNcbiAqIEBwYXJhbSB7Q29tcG9uZW50VHlwZTxTdmVsdGVDb21wb25lbnQ8UHJvcHM+PiB8IENvbXBvbmVudDxQcm9wcywgRXhwb3J0cywgYW55Pn0gY29tcG9uZW50XG4gKiBAcGFyYW0ge01vdW50T3B0aW9uczxQcm9wcz59IG9wdGlvbnNcbiAqIEByZXR1cm5zIHtFeHBvcnRzfVxuICovXG5leHBvcnQgZnVuY3Rpb24gbW91bnQoY29tcG9uZW50LCBvcHRpb25zKSB7XG5cdHJldHVybiBfbW91bnQoY29tcG9uZW50LCBvcHRpb25zKTtcbn1cblxuLyoqXG4gKiBIeWRyYXRlcyBhIGNvbXBvbmVudCBvbiB0aGUgZ2l2ZW4gdGFyZ2V0IGFuZCByZXR1cm5zIHRoZSBleHBvcnRzIGFuZCBwb3RlbnRpYWxseSB0aGUgcHJvcHMgKGlmIGNvbXBpbGVkIHdpdGggYGFjY2Vzc29yczogdHJ1ZWApIG9mIHRoZSBjb21wb25lbnRcbiAqXG4gKiBAdGVtcGxhdGUge1JlY29yZDxzdHJpbmcsIGFueT59IFByb3BzXG4gKiBAdGVtcGxhdGUge1JlY29yZDxzdHJpbmcsIGFueT59IEV4cG9ydHNcbiAqIEBwYXJhbSB7Q29tcG9uZW50VHlwZTxTdmVsdGVDb21wb25lbnQ8UHJvcHM+PiB8IENvbXBvbmVudDxQcm9wcywgRXhwb3J0cywgYW55Pn0gY29tcG9uZW50XG4gKiBAcGFyYW0ge3t9IGV4dGVuZHMgUHJvcHMgPyB7XG4gKiBcdFx0dGFyZ2V0OiBEb2N1bWVudCB8IEVsZW1lbnQgfCBTaGFkb3dSb290O1xuICogXHRcdHByb3BzPzogUHJvcHM7XG4gKiBcdFx0ZXZlbnRzPzogUmVjb3JkPHN0cmluZywgKGU6IGFueSkgPT4gYW55PjtcbiAqICBcdGNvbnRleHQ/OiBNYXA8YW55LCBhbnk+O1xuICogXHRcdGludHJvPzogYm9vbGVhbjtcbiAqIFx0XHRyZWNvdmVyPzogYm9vbGVhbjtcbiAqIFx0fSA6IHtcbiAqIFx0XHR0YXJnZXQ6IERvY3VtZW50IHwgRWxlbWVudCB8IFNoYWRvd1Jvb3Q7XG4gKiBcdFx0cHJvcHM6IFByb3BzO1xuICogXHRcdGV2ZW50cz86IFJlY29yZDxzdHJpbmcsIChlOiBhbnkpID0+IGFueT47XG4gKiAgXHRjb250ZXh0PzogTWFwPGFueSwgYW55PjtcbiAqIFx0XHRpbnRybz86IGJvb2xlYW47XG4gKiBcdFx0cmVjb3Zlcj86IGJvb2xlYW47XG4gKiBcdH19IG9wdGlvbnNcbiAqIEByZXR1cm5zIHtFeHBvcnRzfVxuICovXG5leHBvcnQgZnVuY3Rpb24gaHlkcmF0ZShjb21wb25lbnQsIG9wdGlvbnMpIHtcblx0aW5pdF9vcGVyYXRpb25zKCk7XG5cdG9wdGlvbnMuaW50cm8gPSBvcHRpb25zLmludHJvID8/IGZhbHNlO1xuXHRjb25zdCB0YXJnZXQgPSBvcHRpb25zLnRhcmdldDtcblx0Y29uc3Qgd2FzX2h5ZHJhdGluZyA9IGh5ZHJhdGluZztcblx0Y29uc3QgcHJldmlvdXNfaHlkcmF0ZV9ub2RlID0gaHlkcmF0ZV9ub2RlO1xuXG5cdHRyeSB7XG5cdFx0dmFyIGFuY2hvciA9IC8qKiBAdHlwZSB7VGVtcGxhdGVOb2RlfSAqLyAoZ2V0X2ZpcnN0X2NoaWxkKHRhcmdldCkpO1xuXHRcdHdoaWxlIChcblx0XHRcdGFuY2hvciAmJlxuXHRcdFx0KGFuY2hvci5ub2RlVHlwZSAhPT0gOCB8fCAvKiogQHR5cGUge0NvbW1lbnR9ICovIChhbmNob3IpLmRhdGEgIT09IEhZRFJBVElPTl9TVEFSVClcblx0XHQpIHtcblx0XHRcdGFuY2hvciA9IC8qKiBAdHlwZSB7VGVtcGxhdGVOb2RlfSAqLyAoZ2V0X25leHRfc2libGluZyhhbmNob3IpKTtcblx0XHR9XG5cblx0XHRpZiAoIWFuY2hvcikge1xuXHRcdFx0dGhyb3cgSFlEUkFUSU9OX0VSUk9SO1xuXHRcdH1cblxuXHRcdHNldF9oeWRyYXRpbmcodHJ1ZSk7XG5cdFx0c2V0X2h5ZHJhdGVfbm9kZSgvKiogQHR5cGUge0NvbW1lbnR9ICovIChhbmNob3IpKTtcblx0XHRoeWRyYXRlX25leHQoKTtcblxuXHRcdGNvbnN0IGluc3RhbmNlID0gX21vdW50KGNvbXBvbmVudCwgeyAuLi5vcHRpb25zLCBhbmNob3IgfSk7XG5cblx0XHRpZiAoXG5cdFx0XHRoeWRyYXRlX25vZGUgPT09IG51bGwgfHxcblx0XHRcdGh5ZHJhdGVfbm9kZS5ub2RlVHlwZSAhPT0gOCB8fFxuXHRcdFx0LyoqIEB0eXBlIHtDb21tZW50fSAqLyAoaHlkcmF0ZV9ub2RlKS5kYXRhICE9PSBIWURSQVRJT05fRU5EXG5cdFx0KSB7XG5cdFx0XHR3Lmh5ZHJhdGlvbl9taXNtYXRjaCgpO1xuXHRcdFx0dGhyb3cgSFlEUkFUSU9OX0VSUk9SO1xuXHRcdH1cblxuXHRcdHNldF9oeWRyYXRpbmcoZmFsc2UpO1xuXG5cdFx0cmV0dXJuIC8qKiAgQHR5cGUge0V4cG9ydHN9ICovIChpbnN0YW5jZSk7XG5cdH0gY2F0Y2ggKGVycm9yKSB7XG5cdFx0aWYgKGVycm9yID09PSBIWURSQVRJT05fRVJST1IpIHtcblx0XHRcdGlmIChvcHRpb25zLnJlY292ZXIgPT09IGZhbHNlKSB7XG5cdFx0XHRcdGUuaHlkcmF0aW9uX2ZhaWxlZCgpO1xuXHRcdFx0fVxuXG5cdFx0XHQvLyBJZiBhbiBlcnJvciBvY2N1cmVkIGFib3ZlLCB0aGUgb3BlcmF0aW9ucyBtaWdodCBub3QgeWV0IGhhdmUgYmVlbiBpbml0aWFsaXNlZC5cblx0XHRcdGluaXRfb3BlcmF0aW9ucygpO1xuXHRcdFx0Y2xlYXJfdGV4dF9jb250ZW50KHRhcmdldCk7XG5cblx0XHRcdHNldF9oeWRyYXRpbmcoZmFsc2UpO1xuXHRcdFx0cmV0dXJuIG1vdW50KGNvbXBvbmVudCwgb3B0aW9ucyk7XG5cdFx0fVxuXG5cdFx0dGhyb3cgZXJyb3I7XG5cdH0gZmluYWxseSB7XG5cdFx0c2V0X2h5ZHJhdGluZyh3YXNfaHlkcmF0aW5nKTtcblx0XHRzZXRfaHlkcmF0ZV9ub2RlKHByZXZpb3VzX2h5ZHJhdGVfbm9kZSk7XG5cdFx0cmVzZXRfaGVhZF9hbmNob3IoKTtcblx0fVxufVxuXG4vKiogQHR5cGUge01hcDxzdHJpbmcsIG51bWJlcj59ICovXG5jb25zdCBkb2N1bWVudF9saXN0ZW5lcnMgPSBuZXcgTWFwKCk7XG5cbi8qKlxuICogQHRlbXBsYXRlIHtSZWNvcmQ8c3RyaW5nLCBhbnk+fSBFeHBvcnRzXG4gKiBAcGFyYW0ge0NvbXBvbmVudFR5cGU8U3ZlbHRlQ29tcG9uZW50PGFueT4+IHwgQ29tcG9uZW50PGFueT59IENvbXBvbmVudFxuICogQHBhcmFtIHtNb3VudE9wdGlvbnN9IG9wdGlvbnNcbiAqIEByZXR1cm5zIHtFeHBvcnRzfVxuICovXG5mdW5jdGlvbiBfbW91bnQoQ29tcG9uZW50LCB7IHRhcmdldCwgYW5jaG9yLCBwcm9wcyA9IHt9LCBldmVudHMsIGNvbnRleHQsIGludHJvID0gdHJ1ZSB9KSB7XG5cdGluaXRfb3BlcmF0aW9ucygpO1xuXG5cdHZhciByZWdpc3RlcmVkX2V2ZW50cyA9IG5ldyBTZXQoKTtcblxuXHQvKiogQHBhcmFtIHtBcnJheTxzdHJpbmc+fSBldmVudHMgKi9cblx0dmFyIGV2ZW50X2hhbmRsZSA9IChldmVudHMpID0+IHtcblx0XHRmb3IgKHZhciBpID0gMDsgaSA8IGV2ZW50cy5sZW5ndGg7IGkrKykge1xuXHRcdFx0dmFyIGV2ZW50X25hbWUgPSBldmVudHNbaV07XG5cblx0XHRcdGlmIChyZWdpc3RlcmVkX2V2ZW50cy5oYXMoZXZlbnRfbmFtZSkpIGNvbnRpbnVlO1xuXHRcdFx0cmVnaXN0ZXJlZF9ldmVudHMuYWRkKGV2ZW50X25hbWUpO1xuXG5cdFx0XHR2YXIgcGFzc2l2ZSA9IGlzX3Bhc3NpdmVfZXZlbnQoZXZlbnRfbmFtZSk7XG5cblx0XHRcdC8vIEFkZCB0aGUgZXZlbnQgbGlzdGVuZXIgdG8gYm90aCB0aGUgY29udGFpbmVyIGFuZCB0aGUgZG9jdW1lbnQuXG5cdFx0XHQvLyBUaGUgY29udGFpbmVyIGxpc3RlbmVyIGVuc3VyZXMgd2UgY2F0Y2ggZXZlbnRzIGZyb20gd2l0aGluIGluIGNhc2Vcblx0XHRcdC8vIHRoZSBvdXRlciBjb250ZW50IHN0b3BzIHByb3BhZ2F0aW9uIG9mIHRoZSBldmVudC5cblx0XHRcdHRhcmdldC5hZGRFdmVudExpc3RlbmVyKGV2ZW50X25hbWUsIGhhbmRsZV9ldmVudF9wcm9wYWdhdGlvbiwgeyBwYXNzaXZlIH0pO1xuXG5cdFx0XHR2YXIgbiA9IGRvY3VtZW50X2xpc3RlbmVycy5nZXQoZXZlbnRfbmFtZSk7XG5cblx0XHRcdGlmIChuID09PSB1bmRlZmluZWQpIHtcblx0XHRcdFx0Ly8gVGhlIGRvY3VtZW50IGxpc3RlbmVyIGVuc3VyZXMgd2UgY2F0Y2ggZXZlbnRzIHRoYXQgb3JpZ2luYXRlIGZyb20gZWxlbWVudHMgdGhhdCB3ZXJlXG5cdFx0XHRcdC8vIG1hbnVhbGx5IG1vdmVkIG91dHNpZGUgb2YgdGhlIGNvbnRhaW5lciAoZS5nLiB2aWEgbWFudWFsIHBvcnRhbHMpLlxuXHRcdFx0XHRkb2N1bWVudC5hZGRFdmVudExpc3RlbmVyKGV2ZW50X25hbWUsIGhhbmRsZV9ldmVudF9wcm9wYWdhdGlvbiwgeyBwYXNzaXZlIH0pO1xuXHRcdFx0XHRkb2N1bWVudF9saXN0ZW5lcnMuc2V0KGV2ZW50X25hbWUsIDEpO1xuXHRcdFx0fSBlbHNlIHtcblx0XHRcdFx0ZG9jdW1lbnRfbGlzdGVuZXJzLnNldChldmVudF9uYW1lLCBuICsgMSk7XG5cdFx0XHR9XG5cdFx0fVxuXHR9O1xuXG5cdGV2ZW50X2hhbmRsZShhcnJheV9mcm9tKGFsbF9yZWdpc3RlcmVkX2V2ZW50cykpO1xuXHRyb290X2V2ZW50X2hhbmRsZXMuYWRkKGV2ZW50X2hhbmRsZSk7XG5cblx0LyoqIEB0eXBlIHtFeHBvcnRzfSAqL1xuXHQvLyBAdHMtZXhwZWN0LWVycm9yIHdpbGwgYmUgZGVmaW5lZCBiZWNhdXNlIHRoZSByZW5kZXIgZWZmZWN0IHJ1bnMgc3luY2hyb25vdXNseVxuXHR2YXIgY29tcG9uZW50ID0gdW5kZWZpbmVkO1xuXG5cdHZhciB1bm1vdW50ID0gY29tcG9uZW50X3Jvb3QoKCkgPT4ge1xuXHRcdHZhciBhbmNob3Jfbm9kZSA9IGFuY2hvciA/PyB0YXJnZXQuYXBwZW5kQ2hpbGQoY3JlYXRlX3RleHQoKSk7XG5cblx0XHRicmFuY2goKCkgPT4ge1xuXHRcdFx0aWYgKGNvbnRleHQpIHtcblx0XHRcdFx0cHVzaCh7fSk7XG5cdFx0XHRcdHZhciBjdHggPSAvKiogQHR5cGUge0NvbXBvbmVudENvbnRleHR9ICovIChjb21wb25lbnRfY29udGV4dCk7XG5cdFx0XHRcdGN0eC5jID0gY29udGV4dDtcblx0XHRcdH1cblxuXHRcdFx0aWYgKGV2ZW50cykge1xuXHRcdFx0XHQvLyBXZSBjYW4ndCBzcHJlYWQgdGhlIG9iamVjdCBvciBlbHNlIHdlJ2QgbG9zZSB0aGUgc3RhdGUgcHJveHkgc3R1ZmYsIGlmIGl0IGlzIG9uZVxuXHRcdFx0XHQvKiogQHR5cGUge2FueX0gKi8gKHByb3BzKS4kJGV2ZW50cyA9IGV2ZW50cztcblx0XHRcdH1cblxuXHRcdFx0aWYgKGh5ZHJhdGluZykge1xuXHRcdFx0XHRhc3NpZ25fbm9kZXMoLyoqIEB0eXBlIHtUZW1wbGF0ZU5vZGV9ICovIChhbmNob3Jfbm9kZSksIG51bGwpO1xuXHRcdFx0fVxuXG5cdFx0XHRzaG91bGRfaW50cm8gPSBpbnRybztcblx0XHRcdC8vIEB0cy1leHBlY3QtZXJyb3IgdGhlIHB1YmxpYyB0eXBpbmdzIGFyZSBub3Qgd2hhdCB0aGUgYWN0dWFsIGZ1bmN0aW9uIGxvb2tzIGxpa2Vcblx0XHRcdGNvbXBvbmVudCA9IENvbXBvbmVudChhbmNob3Jfbm9kZSwgcHJvcHMpIHx8IHt9O1xuXHRcdFx0c2hvdWxkX2ludHJvID0gdHJ1ZTtcblxuXHRcdFx0aWYgKGh5ZHJhdGluZykge1xuXHRcdFx0XHQvKiogQHR5cGUge0VmZmVjdH0gKi8gKGFjdGl2ZV9lZmZlY3QpLm5vZGVzX2VuZCA9IGh5ZHJhdGVfbm9kZTtcblx0XHRcdH1cblxuXHRcdFx0aWYgKGNvbnRleHQpIHtcblx0XHRcdFx0cG9wKCk7XG5cdFx0XHR9XG5cdFx0fSk7XG5cblx0XHRyZXR1cm4gKCkgPT4ge1xuXHRcdFx0Zm9yICh2YXIgZXZlbnRfbmFtZSBvZiByZWdpc3RlcmVkX2V2ZW50cykge1xuXHRcdFx0XHR0YXJnZXQucmVtb3ZlRXZlbnRMaXN0ZW5lcihldmVudF9uYW1lLCBoYW5kbGVfZXZlbnRfcHJvcGFnYXRpb24pO1xuXG5cdFx0XHRcdHZhciBuID0gLyoqIEB0eXBlIHtudW1iZXJ9ICovIChkb2N1bWVudF9saXN0ZW5lcnMuZ2V0KGV2ZW50X25hbWUpKTtcblxuXHRcdFx0XHRpZiAoLS1uID09PSAwKSB7XG5cdFx0XHRcdFx0ZG9jdW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcihldmVudF9uYW1lLCBoYW5kbGVfZXZlbnRfcHJvcGFnYXRpb24pO1xuXHRcdFx0XHRcdGRvY3VtZW50X2xpc3RlbmVycy5kZWxldGUoZXZlbnRfbmFtZSk7XG5cdFx0XHRcdH0gZWxzZSB7XG5cdFx0XHRcdFx0ZG9jdW1lbnRfbGlzdGVuZXJzLnNldChldmVudF9uYW1lLCBuKTtcblx0XHRcdFx0fVxuXHRcdFx0fVxuXG5cdFx0XHRyb290X2V2ZW50X2hhbmRsZXMuZGVsZXRlKGV2ZW50X2hhbmRsZSk7XG5cblx0XHRcdGlmIChhbmNob3Jfbm9kZSAhPT0gYW5jaG9yKSB7XG5cdFx0XHRcdGFuY2hvcl9ub2RlLnBhcmVudE5vZGU/LnJlbW92ZUNoaWxkKGFuY2hvcl9ub2RlKTtcblx0XHRcdH1cblx0XHR9O1xuXHR9KTtcblxuXHRtb3VudGVkX2NvbXBvbmVudHMuc2V0KGNvbXBvbmVudCwgdW5tb3VudCk7XG5cdHJldHVybiBjb21wb25lbnQ7XG59XG5cbi8qKlxuICogUmVmZXJlbmNlcyBvZiB0aGUgY29tcG9uZW50cyB0aGF0IHdlcmUgbW91bnRlZCBvciBoeWRyYXRlZC5cbiAqIFVzZXMgYSBgV2Vha01hcGAgdG8gYXZvaWQgbWVtb3J5IGxlYWtzLlxuICovXG5sZXQgbW91bnRlZF9jb21wb25lbnRzID0gbmV3IFdlYWtNYXAoKTtcblxuLyoqXG4gKiBVbm1vdW50cyBhIGNvbXBvbmVudCB0aGF0IHdhcyBwcmV2aW91c2x5IG1vdW50ZWQgdXNpbmcgYG1vdW50YCBvciBgaHlkcmF0ZWAuXG4gKlxuICogU2luY2UgNS4xMy4wLCBpZiBgb3B0aW9ucy5vdXRyb2AgaXMgYHRydWVgLCBbdHJhbnNpdGlvbnNdKGh0dHBzOi8vc3ZlbHRlLmRldi9kb2NzL3N2ZWx0ZS90cmFuc2l0aW9uKSB3aWxsIHBsYXkgYmVmb3JlIHRoZSBjb21wb25lbnQgaXMgcmVtb3ZlZCBmcm9tIHRoZSBET00uXG4gKlxuICogUmV0dXJucyBhIGBQcm9taXNlYCB0aGF0IHJlc29sdmVzIGFmdGVyIHRyYW5zaXRpb25zIGhhdmUgY29tcGxldGVkIGlmIGBvcHRpb25zLm91dHJvYCBpcyB0cnVlLCBvciBpbW1lZGlhdGVseSBvdGhlcndpc2UgKHByaW9yIHRvIDUuMTMuMCwgcmV0dXJucyBgdm9pZGApLlxuICpcbiAqIGBgYGpzXG4gKiBpbXBvcnQgeyBtb3VudCwgdW5tb3VudCB9IGZyb20gJ3N2ZWx0ZSc7XG4gKiBpbXBvcnQgQXBwIGZyb20gJy4vQXBwLnN2ZWx0ZSc7XG4gKlxuICogY29uc3QgYXBwID0gbW91bnQoQXBwLCB7IHRhcmdldDogZG9jdW1lbnQuYm9keSB9KTtcbiAqXG4gKiAvLyBsYXRlci4uLlxuICogdW5tb3VudChhcHAsIHsgb3V0cm86IHRydWUgfSk7XG4gKiBgYGBcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgYW55Pn0gY29tcG9uZW50XG4gKiBAcGFyYW0ge3sgb3V0cm8/OiBib29sZWFuIH19IFtvcHRpb25zXVxuICogQHJldHVybnMge1Byb21pc2U8dm9pZD59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiB1bm1vdW50KGNvbXBvbmVudCwgb3B0aW9ucykge1xuXHRjb25zdCBmbiA9IG1vdW50ZWRfY29tcG9uZW50cy5nZXQoY29tcG9uZW50KTtcblxuXHRpZiAoZm4pIHtcblx0XHRtb3VudGVkX2NvbXBvbmVudHMuZGVsZXRlKGNvbXBvbmVudCk7XG5cdFx0cmV0dXJuIGZuKG9wdGlvbnMpO1xuXHR9XG5cblx0aWYgKERFVikge1xuXHRcdHcubGlmZWN5Y2xlX2RvdWJsZV91bm1vdW50KCk7XG5cdH1cblxuXHRyZXR1cm4gUHJvbWlzZS5yZXNvbHZlKCk7XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBTdG9yZVJlZmVyZW5jZXNDb250YWluZXIgfSBmcm9tICcjY2xpZW50JyAqL1xuLyoqIEBpbXBvcnQgeyBTdG9yZSB9IGZyb20gJyNzaGFyZWQnICovXG5pbXBvcnQgeyBzdWJzY3JpYmVfdG9fc3RvcmUgfSBmcm9tICcuLi8uLi8uLi9zdG9yZS91dGlscy5qcyc7XG5pbXBvcnQgeyBnZXQgYXMgZ2V0X3N0b3JlIH0gZnJvbSAnLi4vLi4vLi4vc3RvcmUvc2hhcmVkL2luZGV4LmpzJztcbmltcG9ydCB7IGRlZmluZV9wcm9wZXJ0eSwgbm9vcCB9IGZyb20gJy4uLy4uL3NoYXJlZC91dGlscy5qcyc7XG5pbXBvcnQgeyBnZXQgfSBmcm9tICcuLi9ydW50aW1lLmpzJztcbmltcG9ydCB7IHRlYXJkb3duIH0gZnJvbSAnLi9lZmZlY3RzLmpzJztcbmltcG9ydCB7IG11dGFibGVfc291cmNlLCBzZXQgfSBmcm9tICcuL3NvdXJjZXMuanMnO1xuXG4vKipcbiAqIFdoZXRoZXIgb3Igbm90IHRoZSBwcm9wIGN1cnJlbnRseSBiZWluZyByZWFkIGlzIGEgc3RvcmUgYmluZGluZywgYXMgaW5cbiAqIGA8Q2hpbGQgYmluZDp4PXskeX0gLz5gLiBJZiBpdCBpcywgd2UgdHJlYXQgdGhlIHByb3AgYXMgbXV0YWJsZSBldmVuIGluXG4gKiBydW5lcyBtb2RlLCBhbmQgc2tpcCBgYmluZGluZ19wcm9wZXJ0eV9ub25fcmVhY3RpdmVgIHZhbGlkYXRpb25cbiAqL1xubGV0IGlzX3N0b3JlX2JpbmRpbmcgPSBmYWxzZTtcblxubGV0IElTX1VOTU9VTlRFRCA9IFN5bWJvbCgpO1xuXG4vKipcbiAqIEdldHMgdGhlIGN1cnJlbnQgdmFsdWUgb2YgYSBzdG9yZS4gSWYgdGhlIHN0b3JlIGlzbid0IHN1YnNjcmliZWQgdG8geWV0LCBpdCB3aWxsIGNyZWF0ZSBhIHByb3h5XG4gKiBzaWduYWwgdGhhdCB3aWxsIGJlIHVwZGF0ZWQgd2hlbiB0aGUgc3RvcmUgaXMuIFRoZSBzdG9yZSByZWZlcmVuY2VzIGNvbnRhaW5lciBpcyBuZWVkZWQgdG9cbiAqIHRyYWNrIHJlYXNzaWdubWVudHMgdG8gc3RvcmVzIGFuZCB0byB0cmFjayB0aGUgY29ycmVjdCBjb21wb25lbnQgY29udGV4dC5cbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0ge1N0b3JlPFY+IHwgbnVsbCB8IHVuZGVmaW5lZH0gc3RvcmVcbiAqIEBwYXJhbSB7c3RyaW5nfSBzdG9yZV9uYW1lXG4gKiBAcGFyYW0ge1N0b3JlUmVmZXJlbmNlc0NvbnRhaW5lcn0gc3RvcmVzXG4gKiBAcmV0dXJucyB7Vn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHN0b3JlX2dldChzdG9yZSwgc3RvcmVfbmFtZSwgc3RvcmVzKSB7XG5cdGNvbnN0IGVudHJ5ID0gKHN0b3Jlc1tzdG9yZV9uYW1lXSA/Pz0ge1xuXHRcdHN0b3JlOiBudWxsLFxuXHRcdHNvdXJjZTogbXV0YWJsZV9zb3VyY2UodW5kZWZpbmVkKSxcblx0XHR1bnN1YnNjcmliZTogbm9vcFxuXHR9KTtcblxuXHQvLyBpZiB0aGUgY29tcG9uZW50IHRoYXQgc2V0dXAgdGhpcyBpcyBhbHJlYWR5IHVubW91bnRlZCB3ZSBkb24ndCB3YW50IHRvIHJlZ2lzdGVyIGEgc3Vic2NyaXB0aW9uXG5cdGlmIChlbnRyeS5zdG9yZSAhPT0gc3RvcmUgJiYgIShJU19VTk1PVU5URUQgaW4gc3RvcmVzKSkge1xuXHRcdGVudHJ5LnVuc3Vic2NyaWJlKCk7XG5cdFx0ZW50cnkuc3RvcmUgPSBzdG9yZSA/PyBudWxsO1xuXG5cdFx0aWYgKHN0b3JlID09IG51bGwpIHtcblx0XHRcdGVudHJ5LnNvdXJjZS52ID0gdW5kZWZpbmVkOyAvLyBzZWUgc3luY2hyb25vdXMgY2FsbGJhY2sgY29tbWVudCBiZWxvd1xuXHRcdFx0ZW50cnkudW5zdWJzY3JpYmUgPSBub29wO1xuXHRcdH0gZWxzZSB7XG5cdFx0XHR2YXIgaXNfc3luY2hyb25vdXNfY2FsbGJhY2sgPSB0cnVlO1xuXG5cdFx0XHRlbnRyeS51bnN1YnNjcmliZSA9IHN1YnNjcmliZV90b19zdG9yZShzdG9yZSwgKHYpID0+IHtcblx0XHRcdFx0aWYgKGlzX3N5bmNocm9ub3VzX2NhbGxiYWNrKSB7XG5cdFx0XHRcdFx0Ly8gSWYgdGhlIGZpcnN0IHVwZGF0ZXMgdG8gdGhlIHN0b3JlIHZhbHVlIChwb3NzaWJseSBtdWx0aXBsZSBvZiB0aGVtKSBhcmUgc3luY2hyb25vdXNseVxuXHRcdFx0XHRcdC8vIGluc2lkZSBhIGRlcml2ZWQsIHdlIHdpbGwgaGl0IHRoZSBgc3RhdGVfdW5zYWZlX211dGF0aW9uYCBlcnJvciBpZiB3ZSBgc2V0YCB0aGUgdmFsdWVcblx0XHRcdFx0XHRlbnRyeS5zb3VyY2UudiA9IHY7XG5cdFx0XHRcdH0gZWxzZSB7XG5cdFx0XHRcdFx0c2V0KGVudHJ5LnNvdXJjZSwgdik7XG5cdFx0XHRcdH1cblx0XHRcdH0pO1xuXG5cdFx0XHRpc19zeW5jaHJvbm91c19jYWxsYmFjayA9IGZhbHNlO1xuXHRcdH1cblx0fVxuXG5cdC8vIGlmIHRoZSBjb21wb25lbnQgdGhhdCBzZXR1cCB0aGlzIHN0b3JlcyBpcyBhbHJlYWR5IHVubW91bnRlZCB0aGUgc291cmNlIHdpbGwgYmUgb3V0IG9mIHN5bmNcblx0Ly8gc28gd2UganVzdCB1c2UgdGhlIGBnZXRgIGZvciB0aGUgc3RvcmVzLCBsZXNzIHBlcmZvcm1hbnQgYnV0IGl0IGF2b2lkcyB0byBjcmVhdGUgYSBtZW1vcnkgbGVha1xuXHQvLyBhbmQgaXQgd2lsbCBrZWVwIHRoZSB2YWx1ZSBjb25zaXN0ZW50XG5cdGlmIChzdG9yZSAmJiBJU19VTk1PVU5URUQgaW4gc3RvcmVzKSB7XG5cdFx0cmV0dXJuIGdldF9zdG9yZShzdG9yZSk7XG5cdH1cblxuXHRyZXR1cm4gZ2V0KGVudHJ5LnNvdXJjZSk7XG59XG5cbi8qKlxuICogVW5zdWJzY3JpYmUgZnJvbSBhIHN0b3JlIGlmIGl0J3Mgbm90IHRoZSBzYW1lIGFzIHRoZSBvbmUgaW4gdGhlIHN0b3JlIHJlZmVyZW5jZXMgY29udGFpbmVyLlxuICogV2UgbmVlZCB0aGlzIGluIGFkZGl0aW9uIHRvIGBzdG9yZV9nZXRgIGJlY2F1c2Ugc29tZW9uZSBjb3VsZCB1bnN1YnNjcmliZSBmcm9tIGEgc3RvcmUgYnV0XG4gKiB0aGVuIG5ldmVyIHN1YnNjcmliZSB0byB0aGUgbmV3IG9uZSAoaWYgYW55KSwgY2F1c2luZyB0aGUgc3Vic2NyaXB0aW9uIHRvIHN0YXkgb3BlbiB3cm9uZ2Z1bGx5LlxuICogQHBhcmFtIHtTdG9yZTxhbnk+IHwgbnVsbCB8IHVuZGVmaW5lZH0gc3RvcmVcbiAqIEBwYXJhbSB7c3RyaW5nfSBzdG9yZV9uYW1lXG4gKiBAcGFyYW0ge1N0b3JlUmVmZXJlbmNlc0NvbnRhaW5lcn0gc3RvcmVzXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzdG9yZV91bnN1YihzdG9yZSwgc3RvcmVfbmFtZSwgc3RvcmVzKSB7XG5cdC8qKiBAdHlwZSB7U3RvcmVSZWZlcmVuY2VzQ29udGFpbmVyWycnXSB8IHVuZGVmaW5lZH0gKi9cblx0bGV0IGVudHJ5ID0gc3RvcmVzW3N0b3JlX25hbWVdO1xuXG5cdGlmIChlbnRyeSAmJiBlbnRyeS5zdG9yZSAhPT0gc3RvcmUpIHtcblx0XHQvLyBEb24ndCByZXNldCBzdG9yZSB5ZXQsIHNvIHRoYXQgc3RvcmVfZ2V0IGFib3ZlIGNhbiByZXN1YnNjcmliZSB0byBuZXcgc3RvcmUgaWYgbmVjZXNzYXJ5XG5cdFx0ZW50cnkudW5zdWJzY3JpYmUoKTtcblx0XHRlbnRyeS51bnN1YnNjcmliZSA9IG5vb3A7XG5cdH1cblxuXHRyZXR1cm4gc3RvcmU7XG59XG5cbi8qKlxuICogU2V0cyB0aGUgbmV3IHZhbHVlIG9mIGEgc3RvcmUgYW5kIHJldHVybnMgdGhhdCB2YWx1ZS5cbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0ge1N0b3JlPFY+fSBzdG9yZVxuICogQHBhcmFtIHtWfSB2YWx1ZVxuICogQHJldHVybnMge1Z9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzdG9yZV9zZXQoc3RvcmUsIHZhbHVlKSB7XG5cdHN0b3JlLnNldCh2YWx1ZSk7XG5cdHJldHVybiB2YWx1ZTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge1N0b3JlUmVmZXJlbmNlc0NvbnRhaW5lcn0gc3RvcmVzXG4gKiBAcGFyYW0ge3N0cmluZ30gc3RvcmVfbmFtZVxuICovXG5leHBvcnQgZnVuY3Rpb24gaW52YWxpZGF0ZV9zdG9yZShzdG9yZXMsIHN0b3JlX25hbWUpIHtcblx0dmFyIGVudHJ5ID0gc3RvcmVzW3N0b3JlX25hbWVdO1xuXHRpZiAoZW50cnkuc3RvcmUgIT09IG51bGwpIHtcblx0XHRzdG9yZV9zZXQoZW50cnkuc3RvcmUsIGVudHJ5LnNvdXJjZS52KTtcblx0fVxufVxuXG4vKipcbiAqIFVuc3Vic2NyaWJlcyBmcm9tIGFsbCBhdXRvLXN1YnNjcmliZWQgc3RvcmVzIG9uIGRlc3Ryb3lcbiAqIEByZXR1cm5zIHtbU3RvcmVSZWZlcmVuY2VzQ29udGFpbmVyLCAoKT0+dm9pZF19XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzZXR1cF9zdG9yZXMoKSB7XG5cdC8qKiBAdHlwZSB7U3RvcmVSZWZlcmVuY2VzQ29udGFpbmVyfSAqL1xuXHRjb25zdCBzdG9yZXMgPSB7fTtcblxuXHRmdW5jdGlvbiBjbGVhbnVwKCkge1xuXHRcdHRlYXJkb3duKCgpID0+IHtcblx0XHRcdGZvciAodmFyIHN0b3JlX25hbWUgaW4gc3RvcmVzKSB7XG5cdFx0XHRcdGNvbnN0IHJlZiA9IHN0b3Jlc1tzdG9yZV9uYW1lXTtcblx0XHRcdFx0cmVmLnVuc3Vic2NyaWJlKCk7XG5cdFx0XHR9XG5cdFx0XHRkZWZpbmVfcHJvcGVydHkoc3RvcmVzLCBJU19VTk1PVU5URUQsIHtcblx0XHRcdFx0ZW51bWVyYWJsZTogZmFsc2UsXG5cdFx0XHRcdHZhbHVlOiB0cnVlXG5cdFx0XHR9KTtcblx0XHR9KTtcblx0fVxuXG5cdHJldHVybiBbc3RvcmVzLCBjbGVhbnVwXTtcbn1cblxuLyoqXG4gKiBVcGRhdGVzIGEgc3RvcmUgd2l0aCBhIG5ldyB2YWx1ZS5cbiAqIEBwYXJhbSB7U3RvcmU8Vj59IHN0b3JlICB0aGUgc3RvcmUgdG8gdXBkYXRlXG4gKiBAcGFyYW0ge2FueX0gZXhwcmVzc2lvbiAgdGhlIGV4cHJlc3Npb24gdGhhdCBtdXRhdGVzIHRoZSBzdG9yZVxuICogQHBhcmFtIHtWfSBuZXdfdmFsdWUgIHRoZSBuZXcgc3RvcmUgdmFsdWVcbiAqIEB0ZW1wbGF0ZSBWXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzdG9yZV9tdXRhdGUoc3RvcmUsIGV4cHJlc3Npb24sIG5ld192YWx1ZSkge1xuXHRzdG9yZS5zZXQobmV3X3ZhbHVlKTtcblx0cmV0dXJuIGV4cHJlc3Npb247XG59XG5cbi8qKlxuICogQHBhcmFtIHtTdG9yZTxudW1iZXI+fSBzdG9yZVxuICogQHBhcmFtIHtudW1iZXJ9IHN0b3JlX3ZhbHVlXG4gKiBAcGFyYW0gezEgfCAtMX0gW2RdXG4gKiBAcmV0dXJucyB7bnVtYmVyfVxuICovXG5leHBvcnQgZnVuY3Rpb24gdXBkYXRlX3N0b3JlKHN0b3JlLCBzdG9yZV92YWx1ZSwgZCA9IDEpIHtcblx0c3RvcmUuc2V0KHN0b3JlX3ZhbHVlICsgZCk7XG5cdHJldHVybiBzdG9yZV92YWx1ZTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge1N0b3JlPG51bWJlcj59IHN0b3JlXG4gKiBAcGFyYW0ge251bWJlcn0gc3RvcmVfdmFsdWVcbiAqIEBwYXJhbSB7MSB8IC0xfSBbZF1cbiAqIEByZXR1cm5zIHtudW1iZXJ9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiB1cGRhdGVfcHJlX3N0b3JlKHN0b3JlLCBzdG9yZV92YWx1ZSwgZCA9IDEpIHtcblx0Y29uc3QgdmFsdWUgPSBzdG9yZV92YWx1ZSArIGQ7XG5cdHN0b3JlLnNldCh2YWx1ZSk7XG5cdHJldHVybiB2YWx1ZTtcbn1cblxuLyoqXG4gKiBDYWxsZWQgaW5zaWRlIHByb3AgZ2V0dGVycyB0byBjb21tdW5pY2F0ZSB0aGF0IHRoZSBwcm9wIGlzIGEgc3RvcmUgYmluZGluZ1xuICovXG5leHBvcnQgZnVuY3Rpb24gbWFya19zdG9yZV9iaW5kaW5nKCkge1xuXHRpc19zdG9yZV9iaW5kaW5nID0gdHJ1ZTtcbn1cblxuLyoqXG4gKiBSZXR1cm5zIGEgdHVwbGUgdGhhdCBpbmRpY2F0ZXMgd2hldGhlciBgZm4oKWAgcmVhZHMgYSBwcm9wIHRoYXQgaXMgYSBzdG9yZSBiaW5kaW5nLlxuICogVXNlZCB0byBwcmV2ZW50IGBiaW5kaW5nX3Byb3BlcnR5X25vbl9yZWFjdGl2ZWAgdmFsaWRhdGlvbiBmYWxzZSBwb3NpdGl2ZXMgYW5kXG4gKiBlbnN1cmUgdGhhdCB0aGVzZSBwcm9wcyBhcmUgdHJlYXRlZCBhcyBtdXRhYmxlIGV2ZW4gaW4gcnVuZXMgbW9kZVxuICogQHRlbXBsYXRlIFRcbiAqIEBwYXJhbSB7KCkgPT4gVH0gZm5cbiAqIEByZXR1cm5zIHtbVCwgYm9vbGVhbl19XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjYXB0dXJlX3N0b3JlX2JpbmRpbmcoZm4pIHtcblx0dmFyIHByZXZpb3VzX2lzX3N0b3JlX2JpbmRpbmcgPSBpc19zdG9yZV9iaW5kaW5nO1xuXG5cdHRyeSB7XG5cdFx0aXNfc3RvcmVfYmluZGluZyA9IGZhbHNlO1xuXHRcdHJldHVybiBbZm4oKSwgaXNfc3RvcmVfYmluZGluZ107XG5cdH0gZmluYWxseSB7XG5cdFx0aXNfc3RvcmVfYmluZGluZyA9IHByZXZpb3VzX2lzX3N0b3JlX2JpbmRpbmc7XG5cdH1cbn1cbiIsICIvKiogQGltcG9ydCB7IENvbXBvbmVudENvbnN0cnVjdG9yT3B0aW9ucywgQ29tcG9uZW50VHlwZSwgU3ZlbHRlQ29tcG9uZW50LCBDb21wb25lbnQgfSBmcm9tICdzdmVsdGUnICovXG5pbXBvcnQgeyBESVJUWSwgTEVHQUNZX1BST1BTLCBNQVlCRV9ESVJUWSB9IGZyb20gJy4uL2ludGVybmFsL2NsaWVudC9jb25zdGFudHMuanMnO1xuaW1wb3J0IHsgdXNlcl9wcmVfZWZmZWN0IH0gZnJvbSAnLi4vaW50ZXJuYWwvY2xpZW50L3JlYWN0aXZpdHkvZWZmZWN0cy5qcyc7XG5pbXBvcnQgeyBtdXRhYmxlX3NvdXJjZSwgc2V0IH0gZnJvbSAnLi4vaW50ZXJuYWwvY2xpZW50L3JlYWN0aXZpdHkvc291cmNlcy5qcyc7XG5pbXBvcnQgeyBoeWRyYXRlLCBtb3VudCwgdW5tb3VudCB9IGZyb20gJy4uL2ludGVybmFsL2NsaWVudC9yZW5kZXIuanMnO1xuaW1wb3J0IHsgYWN0aXZlX2VmZmVjdCwgZmx1c2hfc3luYywgZ2V0LCBzZXRfc2lnbmFsX3N0YXR1cyB9IGZyb20gJy4uL2ludGVybmFsL2NsaWVudC9ydW50aW1lLmpzJztcbmltcG9ydCB7IGxpZmVjeWNsZV9vdXRzaWRlX2NvbXBvbmVudCB9IGZyb20gJy4uL2ludGVybmFsL3NoYXJlZC9lcnJvcnMuanMnO1xuaW1wb3J0IHsgZGVmaW5lX3Byb3BlcnR5LCBpc19hcnJheSB9IGZyb20gJy4uL2ludGVybmFsL3NoYXJlZC91dGlscy5qcyc7XG5pbXBvcnQgKiBhcyB3IGZyb20gJy4uL2ludGVybmFsL2NsaWVudC93YXJuaW5ncy5qcyc7XG5pbXBvcnQgeyBERVYgfSBmcm9tICdlc20tZW52JztcbmltcG9ydCB7IEZJTEVOQU1FIH0gZnJvbSAnLi4vY29uc3RhbnRzLmpzJztcbmltcG9ydCB7IGNvbXBvbmVudF9jb250ZXh0LCBkZXZfY3VycmVudF9jb21wb25lbnRfZnVuY3Rpb24gfSBmcm9tICcuLi9pbnRlcm5hbC9jbGllbnQvY29udGV4dC5qcyc7XG5cbi8qKlxuICogVGFrZXMgdGhlIHNhbWUgb3B0aW9ucyBhcyBhIFN2ZWx0ZSA0IGNvbXBvbmVudCBhbmQgdGhlIGNvbXBvbmVudCBmdW5jdGlvbiBhbmQgcmV0dXJucyBhIFN2ZWx0ZSA0IGNvbXBhdGlibGUgY29tcG9uZW50LlxuICpcbiAqIEBkZXByZWNhdGVkIFVzZSB0aGlzIG9ubHkgYXMgYSB0ZW1wb3Jhcnkgc29sdXRpb24gdG8gbWlncmF0ZSB5b3VyIGltcGVyYXRpdmUgY29tcG9uZW50IGNvZGUgdG8gU3ZlbHRlIDUuXG4gKlxuICogQHRlbXBsYXRlIHtSZWNvcmQ8c3RyaW5nLCBhbnk+fSBQcm9wc1xuICogQHRlbXBsYXRlIHtSZWNvcmQ8c3RyaW5nLCBhbnk+fSBFeHBvcnRzXG4gKiBAdGVtcGxhdGUge1JlY29yZDxzdHJpbmcsIGFueT59IEV2ZW50c1xuICogQHRlbXBsYXRlIHtSZWNvcmQ8c3RyaW5nLCBhbnk+fSBTbG90c1xuICpcbiAqIEBwYXJhbSB7Q29tcG9uZW50Q29uc3RydWN0b3JPcHRpb25zPFByb3BzPiAmIHtcbiAqIFx0Y29tcG9uZW50OiBDb21wb25lbnRUeXBlPFN2ZWx0ZUNvbXBvbmVudDxQcm9wcywgRXZlbnRzLCBTbG90cz4+IHwgQ29tcG9uZW50PFByb3BzPjtcbiAqIH19IG9wdGlvbnNcbiAqIEByZXR1cm5zIHtTdmVsdGVDb21wb25lbnQ8UHJvcHMsIEV2ZW50cywgU2xvdHM+ICYgRXhwb3J0c31cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGNyZWF0ZUNsYXNzQ29tcG9uZW50KG9wdGlvbnMpIHtcblx0Ly8gQHRzLWV4cGVjdC1lcnJvciAkJHByb3BfZGVmIGV0YyBhcmUgbm90IGFjdHVhbGx5IGRlZmluZWRcblx0cmV0dXJuIG5ldyBTdmVsdGU0Q29tcG9uZW50KG9wdGlvbnMpO1xufVxuXG4vKipcbiAqIFRha2VzIHRoZSBjb21wb25lbnQgZnVuY3Rpb24gYW5kIHJldHVybnMgYSBTdmVsdGUgNCBjb21wYXRpYmxlIGNvbXBvbmVudCBjb25zdHJ1Y3Rvci5cbiAqXG4gKiBAZGVwcmVjYXRlZCBVc2UgdGhpcyBvbmx5IGFzIGEgdGVtcG9yYXJ5IHNvbHV0aW9uIHRvIG1pZ3JhdGUgeW91ciBpbXBlcmF0aXZlIGNvbXBvbmVudCBjb2RlIHRvIFN2ZWx0ZSA1LlxuICpcbiAqIEB0ZW1wbGF0ZSB7UmVjb3JkPHN0cmluZywgYW55Pn0gUHJvcHNcbiAqIEB0ZW1wbGF0ZSB7UmVjb3JkPHN0cmluZywgYW55Pn0gRXhwb3J0c1xuICogQHRlbXBsYXRlIHtSZWNvcmQ8c3RyaW5nLCBhbnk+fSBFdmVudHNcbiAqIEB0ZW1wbGF0ZSB7UmVjb3JkPHN0cmluZywgYW55Pn0gU2xvdHNcbiAqXG4gKiBAcGFyYW0ge1N2ZWx0ZUNvbXBvbmVudDxQcm9wcywgRXZlbnRzLCBTbG90cz4gfCBDb21wb25lbnQ8UHJvcHM+fSBjb21wb25lbnRcbiAqIEByZXR1cm5zIHtDb21wb25lbnRUeXBlPFN2ZWx0ZUNvbXBvbmVudDxQcm9wcywgRXZlbnRzLCBTbG90cz4gJiBFeHBvcnRzPn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGFzQ2xhc3NDb21wb25lbnQoY29tcG9uZW50KSB7XG5cdC8vIEB0cy1leHBlY3QtZXJyb3IgJCRwcm9wX2RlZiBldGMgYXJlIG5vdCBhY3R1YWxseSBkZWZpbmVkXG5cdHJldHVybiBjbGFzcyBleHRlbmRzIFN2ZWx0ZTRDb21wb25lbnQge1xuXHRcdC8qKiBAcGFyYW0ge2FueX0gb3B0aW9ucyAqL1xuXHRcdGNvbnN0cnVjdG9yKG9wdGlvbnMpIHtcblx0XHRcdHN1cGVyKHtcblx0XHRcdFx0Y29tcG9uZW50LFxuXHRcdFx0XHQuLi5vcHRpb25zXG5cdFx0XHR9KTtcblx0XHR9XG5cdH07XG59XG5cbi8qKlxuICogU3VwcG9ydCB1c2luZyB0aGUgY29tcG9uZW50IGFzIGJvdGggYSBjbGFzcyBhbmQgZnVuY3Rpb24gZHVyaW5nIHRoZSB0cmFuc2l0aW9uIHBlcmlvZFxuICogQHR5cGVkZWYgIHt7bmV3IChvOiBDb21wb25lbnRDb25zdHJ1Y3Rvck9wdGlvbnMpOiBTdmVsdGVDb21wb25lbnQ7KC4uLmFyZ3M6IFBhcmFtZXRlcnM8Q29tcG9uZW50PFJlY29yZDxzdHJpbmcsIGFueT4+Pik6IFJldHVyblR5cGU8Q29tcG9uZW50PFJlY29yZDxzdHJpbmcsIGFueT4sIFJlY29yZDxzdHJpbmcsIGFueT4+Pjt9fSBMZWdhY3lDb21wb25lbnRUeXBlXG4gKi9cblxuY2xhc3MgU3ZlbHRlNENvbXBvbmVudCB7XG5cdC8qKiBAdHlwZSB7YW55fSAqL1xuXHQjZXZlbnRzO1xuXG5cdC8qKiBAdHlwZSB7UmVjb3JkPHN0cmluZywgYW55Pn0gKi9cblx0I2luc3RhbmNlO1xuXG5cdC8qKlxuXHQgKiBAcGFyYW0ge0NvbXBvbmVudENvbnN0cnVjdG9yT3B0aW9ucyAmIHtcblx0ICogIGNvbXBvbmVudDogYW55O1xuXHQgKiB9fSBvcHRpb25zXG5cdCAqL1xuXHRjb25zdHJ1Y3RvcihvcHRpb25zKSB7XG5cdFx0dmFyIHNvdXJjZXMgPSBuZXcgTWFwKCk7XG5cblx0XHQvKipcblx0XHQgKiBAcGFyYW0ge3N0cmluZyB8IHN5bWJvbH0ga2V5XG5cdFx0ICogQHBhcmFtIHt1bmtub3dufSB2YWx1ZVxuXHRcdCAqL1xuXHRcdHZhciBhZGRfc291cmNlID0gKGtleSwgdmFsdWUpID0+IHtcblx0XHRcdHZhciBzID0gbXV0YWJsZV9zb3VyY2UodmFsdWUpO1xuXHRcdFx0c291cmNlcy5zZXQoa2V5LCBzKTtcblx0XHRcdHJldHVybiBzO1xuXHRcdH07XG5cblx0XHQvLyBSZXBsaWNhdGUgY29hcnNlLWdyYWluZWQgcHJvcHMgdGhyb3VnaCBhIHByb3h5IHRoYXQgaGFzIGEgdmVyc2lvbiBzb3VyY2UgZm9yXG5cdFx0Ly8gZWFjaCBwcm9wZXJ0eSwgd2hpY2ggaXMgaW5jcmVtZW50ZWQgb24gdXBkYXRlcyB0byB0aGUgcHJvcGVydHkgaXRzZWxmLiBEbyBub3Rcblx0XHQvLyB1c2Ugb3VyICRzdGF0ZSBwcm94eSBiZWNhdXNlIHRoYXQgb25lIGhhcyBmaW5lLWdyYWluZWQgcmVhY3Rpdml0eS5cblx0XHRjb25zdCBwcm9wcyA9IG5ldyBQcm94eShcblx0XHRcdHsgLi4uKG9wdGlvbnMucHJvcHMgfHwge30pLCAkJGV2ZW50czoge30gfSxcblx0XHRcdHtcblx0XHRcdFx0Z2V0KHRhcmdldCwgcHJvcCkge1xuXHRcdFx0XHRcdHJldHVybiBnZXQoc291cmNlcy5nZXQocHJvcCkgPz8gYWRkX3NvdXJjZShwcm9wLCBSZWZsZWN0LmdldCh0YXJnZXQsIHByb3ApKSk7XG5cdFx0XHRcdH0sXG5cdFx0XHRcdGhhcyh0YXJnZXQsIHByb3ApIHtcblx0XHRcdFx0XHQvLyBOZWNlc3NhcnkgdG8gbm90IHRocm93IFwiaW52YWxpZCBiaW5kaW5nXCIgdmFsaWRhdGlvbiBlcnJvcnMgb24gdGhlIGNvbXBvbmVudCBzaWRlXG5cdFx0XHRcdFx0aWYgKHByb3AgPT09IExFR0FDWV9QUk9QUykgcmV0dXJuIHRydWU7XG5cblx0XHRcdFx0XHRnZXQoc291cmNlcy5nZXQocHJvcCkgPz8gYWRkX3NvdXJjZShwcm9wLCBSZWZsZWN0LmdldCh0YXJnZXQsIHByb3ApKSk7XG5cdFx0XHRcdFx0cmV0dXJuIFJlZmxlY3QuaGFzKHRhcmdldCwgcHJvcCk7XG5cdFx0XHRcdH0sXG5cdFx0XHRcdHNldCh0YXJnZXQsIHByb3AsIHZhbHVlKSB7XG5cdFx0XHRcdFx0c2V0KHNvdXJjZXMuZ2V0KHByb3ApID8/IGFkZF9zb3VyY2UocHJvcCwgdmFsdWUpLCB2YWx1ZSk7XG5cdFx0XHRcdFx0cmV0dXJuIFJlZmxlY3Quc2V0KHRhcmdldCwgcHJvcCwgdmFsdWUpO1xuXHRcdFx0XHR9XG5cdFx0XHR9XG5cdFx0KTtcblxuXHRcdHRoaXMuI2luc3RhbmNlID0gKG9wdGlvbnMuaHlkcmF0ZSA/IGh5ZHJhdGUgOiBtb3VudCkob3B0aW9ucy5jb21wb25lbnQsIHtcblx0XHRcdHRhcmdldDogb3B0aW9ucy50YXJnZXQsXG5cdFx0XHRhbmNob3I6IG9wdGlvbnMuYW5jaG9yLFxuXHRcdFx0cHJvcHMsXG5cdFx0XHRjb250ZXh0OiBvcHRpb25zLmNvbnRleHQsXG5cdFx0XHRpbnRybzogb3B0aW9ucy5pbnRybyA/PyBmYWxzZSxcblx0XHRcdHJlY292ZXI6IG9wdGlvbnMucmVjb3ZlclxuXHRcdH0pO1xuXG5cdFx0Ly8gV2UgZG9uJ3QgZmx1c2hfc3luYyBmb3IgY3VzdG9tIGVsZW1lbnQgd3JhcHBlcnMgb3IgaWYgdGhlIHVzZXIgZG9lc24ndCB3YW50IGl0XG5cdFx0aWYgKCFvcHRpb25zPy5wcm9wcz8uJCRob3N0IHx8IG9wdGlvbnMuc3luYyA9PT0gZmFsc2UpIHtcblx0XHRcdGZsdXNoX3N5bmMoKTtcblx0XHR9XG5cblx0XHR0aGlzLiNldmVudHMgPSBwcm9wcy4kJGV2ZW50cztcblxuXHRcdGZvciAoY29uc3Qga2V5IG9mIE9iamVjdC5rZXlzKHRoaXMuI2luc3RhbmNlKSkge1xuXHRcdFx0aWYgKGtleSA9PT0gJyRzZXQnIHx8IGtleSA9PT0gJyRkZXN0cm95JyB8fCBrZXkgPT09ICckb24nKSBjb250aW51ZTtcblx0XHRcdGRlZmluZV9wcm9wZXJ0eSh0aGlzLCBrZXksIHtcblx0XHRcdFx0Z2V0KCkge1xuXHRcdFx0XHRcdHJldHVybiB0aGlzLiNpbnN0YW5jZVtrZXldO1xuXHRcdFx0XHR9LFxuXHRcdFx0XHQvKiogQHBhcmFtIHthbnl9IHZhbHVlICovXG5cdFx0XHRcdHNldCh2YWx1ZSkge1xuXHRcdFx0XHRcdHRoaXMuI2luc3RhbmNlW2tleV0gPSB2YWx1ZTtcblx0XHRcdFx0fSxcblx0XHRcdFx0ZW51bWVyYWJsZTogdHJ1ZVxuXHRcdFx0fSk7XG5cdFx0fVxuXG5cdFx0dGhpcy4jaW5zdGFuY2UuJHNldCA9IC8qKiBAcGFyYW0ge1JlY29yZDxzdHJpbmcsIGFueT59IG5leHQgKi8gKG5leHQpID0+IHtcblx0XHRcdE9iamVjdC5hc3NpZ24ocHJvcHMsIG5leHQpO1xuXHRcdH07XG5cblx0XHR0aGlzLiNpbnN0YW5jZS4kZGVzdHJveSA9ICgpID0+IHtcblx0XHRcdHVubW91bnQodGhpcy4jaW5zdGFuY2UpO1xuXHRcdH07XG5cdH1cblxuXHQvKiogQHBhcmFtIHtSZWNvcmQ8c3RyaW5nLCBhbnk+fSBwcm9wcyAqL1xuXHQkc2V0KHByb3BzKSB7XG5cdFx0dGhpcy4jaW5zdGFuY2UuJHNldChwcm9wcyk7XG5cdH1cblxuXHQvKipcblx0ICogQHBhcmFtIHtzdHJpbmd9IGV2ZW50XG5cdCAqIEBwYXJhbSB7KC4uLmFyZ3M6IGFueVtdKSA9PiBhbnl9IGNhbGxiYWNrXG5cdCAqIEByZXR1cm5zIHthbnl9XG5cdCAqL1xuXHQkb24oZXZlbnQsIGNhbGxiYWNrKSB7XG5cdFx0dGhpcy4jZXZlbnRzW2V2ZW50XSA9IHRoaXMuI2V2ZW50c1tldmVudF0gfHwgW107XG5cblx0XHQvKiogQHBhcmFtIHthbnlbXX0gYXJncyAqL1xuXHRcdGNvbnN0IGNiID0gKC4uLmFyZ3MpID0+IGNhbGxiYWNrLmNhbGwodGhpcywgLi4uYXJncyk7XG5cdFx0dGhpcy4jZXZlbnRzW2V2ZW50XS5wdXNoKGNiKTtcblx0XHRyZXR1cm4gKCkgPT4ge1xuXHRcdFx0dGhpcy4jZXZlbnRzW2V2ZW50XSA9IHRoaXMuI2V2ZW50c1tldmVudF0uZmlsdGVyKC8qKiBAcGFyYW0ge2FueX0gZm4gKi8gKGZuKSA9PiBmbiAhPT0gY2IpO1xuXHRcdH07XG5cdH1cblxuXHQkZGVzdHJveSgpIHtcblx0XHR0aGlzLiNpbnN0YW5jZS4kZGVzdHJveSgpO1xuXHR9XG59XG5cbi8qKlxuICogUnVucyB0aGUgZ2l2ZW4gZnVuY3Rpb24gb25jZSBpbW1lZGlhdGVseSBvbiB0aGUgc2VydmVyLCBhbmQgd29ya3MgbGlrZSBgJGVmZmVjdC5wcmVgIG9uIHRoZSBjbGllbnQuXG4gKlxuICogQGRlcHJlY2F0ZWQgVXNlIHRoaXMgb25seSBhcyBhIHRlbXBvcmFyeSBzb2x1dGlvbiB0byBtaWdyYXRlIHlvdXIgY29tcG9uZW50IGNvZGUgdG8gU3ZlbHRlIDUuXG4gKiBAcGFyYW0geygpID0+IHZvaWQgfCAoKCkgPT4gdm9pZCl9IGZuXG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHJ1bihmbikge1xuXHR1c2VyX3ByZV9lZmZlY3QoKCkgPT4ge1xuXHRcdGZuKCk7XG5cdFx0dmFyIGVmZmVjdCA9IC8qKiBAdHlwZSB7aW1wb3J0KCcjY2xpZW50JykuRWZmZWN0fSAqLyAoYWN0aXZlX2VmZmVjdCk7XG5cdFx0Ly8gSWYgdGhlIGVmZmVjdCBpcyBpbW1lZGlhdGVseSBtYWRlIGRpcnR5IGFnYWluLCBtYXJrIGl0IGFzIG1heWJlIGRpcnR5IHRvIGVtdWxhdGUgbGVnYWN5IGJlaGF2aW91clxuXHRcdGlmICgoZWZmZWN0LmYgJiBESVJUWSkgIT09IDApIHtcblx0XHRcdGxldCBmaWxlbmFtZSA9IFwiYSBmaWxlICh3ZSBjYW4ndCBrbm93IHdoaWNoIG9uZSlcIjtcblx0XHRcdGlmIChERVYpIHtcblx0XHRcdFx0Ly8gQHRzLWlnbm9yZVxuXHRcdFx0XHRmaWxlbmFtZSA9IGRldl9jdXJyZW50X2NvbXBvbmVudF9mdW5jdGlvbj8uW0ZJTEVOQU1FXSA/PyBmaWxlbmFtZTtcblx0XHRcdH1cblx0XHRcdHcubGVnYWN5X3JlY3Vyc2l2ZV9yZWFjdGl2ZV9ibG9jayhmaWxlbmFtZSk7XG5cdFx0XHRzZXRfc2lnbmFsX3N0YXR1cyhlZmZlY3QsIE1BWUJFX0RJUlRZKTtcblx0XHR9XG5cdH0pO1xufVxuXG4vKipcbiAqIEZ1bmN0aW9uIHRvIG1pbWljIHRoZSBtdWx0aXBsZSBsaXN0ZW5lcnMgYXZhaWxhYmxlIGluIHN2ZWx0ZSA0XG4gKiBAZGVwcmVjYXRlZFxuICogQHBhcmFtIHtFdmVudExpc3RlbmVyW119IGhhbmRsZXJzXG4gKiBAcmV0dXJucyB7RXZlbnRMaXN0ZW5lcn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGhhbmRsZXJzKC4uLmhhbmRsZXJzKSB7XG5cdHJldHVybiBmdW5jdGlvbiAoZXZlbnQpIHtcblx0XHRjb25zdCB7IHN0b3BJbW1lZGlhdGVQcm9wYWdhdGlvbiB9ID0gZXZlbnQ7XG5cdFx0bGV0IHN0b3BwZWQgPSBmYWxzZTtcblxuXHRcdGV2ZW50LnN0b3BJbW1lZGlhdGVQcm9wYWdhdGlvbiA9ICgpID0+IHtcblx0XHRcdHN0b3BwZWQgPSB0cnVlO1xuXHRcdFx0c3RvcEltbWVkaWF0ZVByb3BhZ2F0aW9uLmNhbGwoZXZlbnQpO1xuXHRcdH07XG5cblx0XHRjb25zdCBlcnJvcnMgPSBbXTtcblxuXHRcdGZvciAoY29uc3QgaGFuZGxlciBvZiBoYW5kbGVycykge1xuXHRcdFx0dHJ5IHtcblx0XHRcdFx0Ly8gQHRzLWV4cGVjdC1lcnJvciBgdGhpc2AgaXMgbm90IHR5cGVkXG5cdFx0XHRcdGhhbmRsZXI/LmNhbGwodGhpcywgZXZlbnQpO1xuXHRcdFx0fSBjYXRjaCAoZSkge1xuXHRcdFx0XHRlcnJvcnMucHVzaChlKTtcblx0XHRcdH1cblxuXHRcdFx0aWYgKHN0b3BwZWQpIHtcblx0XHRcdFx0YnJlYWs7XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0Zm9yIChsZXQgZXJyb3Igb2YgZXJyb3JzKSB7XG5cdFx0XHRxdWV1ZU1pY3JvdGFzaygoKSA9PiB7XG5cdFx0XHRcdHRocm93IGVycm9yO1xuXHRcdFx0fSk7XG5cdFx0fVxuXHR9O1xufVxuXG4vKipcbiAqIEZ1bmN0aW9uIHRvIGNyZWF0ZSBhIGBidWJibGVgIGZ1bmN0aW9uIHRoYXQgbWltaWMgdGhlIGJlaGF2aW9yIG9mIGBvbjpjbGlja2Agd2l0aG91dCBoYW5kbGVyIGF2YWlsYWJsZSBpbiBzdmVsdGUgNC5cbiAqIEBkZXByZWNhdGVkIFVzZSB0aGlzIG9ubHkgYXMgYSB0ZW1wb3Jhcnkgc29sdXRpb24gdG8gbWlncmF0ZSB5b3VyIGF1dG9tYXRpY2FsbHkgZGVsZWdhdGVkIGV2ZW50cyBpbiBTdmVsdGUgNS5cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGNyZWF0ZUJ1YmJsZXIoKSB7XG5cdGNvbnN0IGFjdGl2ZV9jb21wb25lbnRfY29udGV4dCA9IGNvbXBvbmVudF9jb250ZXh0O1xuXHRpZiAoYWN0aXZlX2NvbXBvbmVudF9jb250ZXh0ID09PSBudWxsKSB7XG5cdFx0bGlmZWN5Y2xlX291dHNpZGVfY29tcG9uZW50KCdjcmVhdGVCdWJibGVyJyk7XG5cdH1cblxuXHRyZXR1cm4gKC8qKkB0eXBlIHtzdHJpbmd9Ki8gdHlwZSkgPT4gKC8qKkB0eXBlIHtFdmVudH0qLyBldmVudCkgPT4ge1xuXHRcdGNvbnN0IGV2ZW50cyA9IC8qKiBAdHlwZSB7UmVjb3JkPHN0cmluZywgRnVuY3Rpb24gfCBGdW5jdGlvbltdPn0gKi8gKFxuXHRcdFx0YWN0aXZlX2NvbXBvbmVudF9jb250ZXh0LnMuJCRldmVudHNcblx0XHQpPy5bLyoqIEB0eXBlIHthbnl9ICovICh0eXBlKV07XG5cblx0XHRpZiAoZXZlbnRzKSB7XG5cdFx0XHRjb25zdCBjYWxsYmFja3MgPSBpc19hcnJheShldmVudHMpID8gZXZlbnRzLnNsaWNlKCkgOiBbZXZlbnRzXTtcblx0XHRcdGZvciAoY29uc3QgZm4gb2YgY2FsbGJhY2tzKSB7XG5cdFx0XHRcdGZuLmNhbGwoYWN0aXZlX2NvbXBvbmVudF9jb250ZXh0LngsIGV2ZW50KTtcblx0XHRcdH1cblx0XHRcdHJldHVybiAhZXZlbnQuZGVmYXVsdFByZXZlbnRlZDtcblx0XHR9XG5cdFx0cmV0dXJuIHRydWU7XG5cdH07XG59XG5cbmV4cG9ydCB7XG5cdG9uY2UsXG5cdHByZXZlbnREZWZhdWx0LFxuXHRzZWxmLFxuXHRzdG9wSW1tZWRpYXRlUHJvcGFnYXRpb24sXG5cdHN0b3BQcm9wYWdhdGlvbixcblx0dHJ1c3RlZCxcblx0cGFzc2l2ZSxcblx0bm9ucGFzc2l2ZVxufSBmcm9tICcuLi9pbnRlcm5hbC9jbGllbnQvZG9tL2xlZ2FjeS9ldmVudC1tb2RpZmllcnMuanMnO1xuIiwgImltcG9ydCB7IGNyZWF0ZUNsYXNzQ29tcG9uZW50IH0gZnJvbSAnLi4vLi4vLi4vLi4vbGVnYWN5L2xlZ2FjeS1jbGllbnQuanMnO1xuaW1wb3J0IHsgZGVzdHJveV9lZmZlY3QsIGVmZmVjdF9yb290LCByZW5kZXJfZWZmZWN0IH0gZnJvbSAnLi4vLi4vcmVhY3Rpdml0eS9lZmZlY3RzLmpzJztcbmltcG9ydCB7IGFwcGVuZCB9IGZyb20gJy4uL3RlbXBsYXRlLmpzJztcbmltcG9ydCB7IGRlZmluZV9wcm9wZXJ0eSwgZ2V0X2Rlc2NyaXB0b3IsIG9iamVjdF9rZXlzIH0gZnJvbSAnLi4vLi4vLi4vc2hhcmVkL3V0aWxzLmpzJztcblxuLyoqXG4gKiBAdHlwZWRlZiB7T2JqZWN0fSBDdXN0b21FbGVtZW50UHJvcERlZmluaXRpb25cbiAqIEBwcm9wZXJ0eSB7c3RyaW5nfSBbYXR0cmlidXRlXVxuICogQHByb3BlcnR5IHtib29sZWFufSBbcmVmbGVjdF1cbiAqIEBwcm9wZXJ0eSB7J1N0cmluZyd8J0Jvb2xlYW4nfCdOdW1iZXInfCdBcnJheSd8J09iamVjdCd9IFt0eXBlXVxuICovXG5cbi8qKiBAdHlwZSB7YW55fSAqL1xubGV0IFN2ZWx0ZUVsZW1lbnQ7XG5cbmlmICh0eXBlb2YgSFRNTEVsZW1lbnQgPT09ICdmdW5jdGlvbicpIHtcblx0U3ZlbHRlRWxlbWVudCA9IGNsYXNzIGV4dGVuZHMgSFRNTEVsZW1lbnQge1xuXHRcdC8qKiBUaGUgU3ZlbHRlIGNvbXBvbmVudCBjb25zdHJ1Y3RvciAqL1xuXHRcdCQkY3Rvcjtcblx0XHQvKiogU2xvdHMgKi9cblx0XHQkJHM7XG5cdFx0LyoqIEB0eXBlIHthbnl9IFRoZSBTdmVsdGUgY29tcG9uZW50IGluc3RhbmNlICovXG5cdFx0JCRjO1xuXHRcdC8qKiBXaGV0aGVyIG9yIG5vdCB0aGUgY3VzdG9tIGVsZW1lbnQgaXMgY29ubmVjdGVkICovXG5cdFx0JCRjbiA9IGZhbHNlO1xuXHRcdC8qKiBAdHlwZSB7UmVjb3JkPHN0cmluZywgYW55Pn0gQ29tcG9uZW50IHByb3BzIGRhdGEgKi9cblx0XHQkJGQgPSB7fTtcblx0XHQvKiogYHRydWVgIGlmIGN1cnJlbnRseSBpbiB0aGUgcHJvY2VzcyBvZiByZWZsZWN0aW5nIGNvbXBvbmVudCBwcm9wcyBiYWNrIHRvIGF0dHJpYnV0ZXMgKi9cblx0XHQkJHIgPSBmYWxzZTtcblx0XHQvKiogQHR5cGUge1JlY29yZDxzdHJpbmcsIEN1c3RvbUVsZW1lbnRQcm9wRGVmaW5pdGlvbj59IFByb3BzIGRlZmluaXRpb24gKG5hbWUsIHJlZmxlY3RlZCwgdHlwZSBldGMpICovXG5cdFx0JCRwX2QgPSB7fTtcblx0XHQvKiogQHR5cGUge1JlY29yZDxzdHJpbmcsIEV2ZW50TGlzdGVuZXJPckV2ZW50TGlzdGVuZXJPYmplY3RbXT59IEV2ZW50IGxpc3RlbmVycyAqL1xuXHRcdCQkbCA9IHt9O1xuXHRcdC8qKiBAdHlwZSB7TWFwPEV2ZW50TGlzdGVuZXJPckV2ZW50TGlzdGVuZXJPYmplY3QsIEZ1bmN0aW9uPn0gRXZlbnQgbGlzdGVuZXIgdW5zdWJzY3JpYmUgZnVuY3Rpb25zICovXG5cdFx0JCRsX3UgPSBuZXcgTWFwKCk7XG5cdFx0LyoqIEB0eXBlIHthbnl9IFRoZSBtYW5hZ2VkIHJlbmRlciBlZmZlY3QgZm9yIHJlZmxlY3RpbmcgYXR0cmlidXRlcyAqL1xuXHRcdCQkbWU7XG5cblx0XHQvKipcblx0XHQgKiBAcGFyYW0geyp9ICQkY29tcG9uZW50Q3RvclxuXHRcdCAqIEBwYXJhbSB7Kn0gJCRzbG90c1xuXHRcdCAqIEBwYXJhbSB7Kn0gdXNlX3NoYWRvd19kb21cblx0XHQgKi9cblx0XHRjb25zdHJ1Y3RvcigkJGNvbXBvbmVudEN0b3IsICQkc2xvdHMsIHVzZV9zaGFkb3dfZG9tKSB7XG5cdFx0XHRzdXBlcigpO1xuXHRcdFx0dGhpcy4kJGN0b3IgPSAkJGNvbXBvbmVudEN0b3I7XG5cdFx0XHR0aGlzLiQkcyA9ICQkc2xvdHM7XG5cdFx0XHRpZiAodXNlX3NoYWRvd19kb20pIHtcblx0XHRcdFx0dGhpcy5hdHRhY2hTaGFkb3coeyBtb2RlOiAnb3BlbicgfSk7XG5cdFx0XHR9XG5cdFx0fVxuXG5cdFx0LyoqXG5cdFx0ICogQHBhcmFtIHtzdHJpbmd9IHR5cGVcblx0XHQgKiBAcGFyYW0ge0V2ZW50TGlzdGVuZXJPckV2ZW50TGlzdGVuZXJPYmplY3R9IGxpc3RlbmVyXG5cdFx0ICogQHBhcmFtIHtib29sZWFuIHwgQWRkRXZlbnRMaXN0ZW5lck9wdGlvbnN9IFtvcHRpb25zXVxuXHRcdCAqL1xuXHRcdGFkZEV2ZW50TGlzdGVuZXIodHlwZSwgbGlzdGVuZXIsIG9wdGlvbnMpIHtcblx0XHRcdC8vIFdlIGNhbid0IGRldGVybWluZSB1cGZyb250IGlmIHRoZSBldmVudCBpcyBhIGN1c3RvbSBldmVudCBvciBub3QsIHNvIHdlIGhhdmUgdG9cblx0XHRcdC8vIGxpc3RlbiB0byBib3RoLiBJZiBzb21lb25lIHVzZXMgYSBjdXN0b20gZXZlbnQgd2l0aCB0aGUgc2FtZSBuYW1lIGFzIGEgcmVndWxhclxuXHRcdFx0Ly8gYnJvd3NlciBldmVudCwgdGhpcyBmaXJlcyB0d2ljZSAtIHdlIGNhbid0IGF2b2lkIHRoYXQuXG5cdFx0XHR0aGlzLiQkbFt0eXBlXSA9IHRoaXMuJCRsW3R5cGVdIHx8IFtdO1xuXHRcdFx0dGhpcy4kJGxbdHlwZV0ucHVzaChsaXN0ZW5lcik7XG5cdFx0XHRpZiAodGhpcy4kJGMpIHtcblx0XHRcdFx0Y29uc3QgdW5zdWIgPSB0aGlzLiQkYy4kb24odHlwZSwgbGlzdGVuZXIpO1xuXHRcdFx0XHR0aGlzLiQkbF91LnNldChsaXN0ZW5lciwgdW5zdWIpO1xuXHRcdFx0fVxuXHRcdFx0c3VwZXIuYWRkRXZlbnRMaXN0ZW5lcih0eXBlLCBsaXN0ZW5lciwgb3B0aW9ucyk7XG5cdFx0fVxuXG5cdFx0LyoqXG5cdFx0ICogQHBhcmFtIHtzdHJpbmd9IHR5cGVcblx0XHQgKiBAcGFyYW0ge0V2ZW50TGlzdGVuZXJPckV2ZW50TGlzdGVuZXJPYmplY3R9IGxpc3RlbmVyXG5cdFx0ICogQHBhcmFtIHtib29sZWFuIHwgQWRkRXZlbnRMaXN0ZW5lck9wdGlvbnN9IFtvcHRpb25zXVxuXHRcdCAqL1xuXHRcdHJlbW92ZUV2ZW50TGlzdGVuZXIodHlwZSwgbGlzdGVuZXIsIG9wdGlvbnMpIHtcblx0XHRcdHN1cGVyLnJlbW92ZUV2ZW50TGlzdGVuZXIodHlwZSwgbGlzdGVuZXIsIG9wdGlvbnMpO1xuXHRcdFx0aWYgKHRoaXMuJCRjKSB7XG5cdFx0XHRcdGNvbnN0IHVuc3ViID0gdGhpcy4kJGxfdS5nZXQobGlzdGVuZXIpO1xuXHRcdFx0XHRpZiAodW5zdWIpIHtcblx0XHRcdFx0XHR1bnN1YigpO1xuXHRcdFx0XHRcdHRoaXMuJCRsX3UuZGVsZXRlKGxpc3RlbmVyKTtcblx0XHRcdFx0fVxuXHRcdFx0fVxuXHRcdH1cblxuXHRcdGFzeW5jIGNvbm5lY3RlZENhbGxiYWNrKCkge1xuXHRcdFx0dGhpcy4kJGNuID0gdHJ1ZTtcblx0XHRcdGlmICghdGhpcy4kJGMpIHtcblx0XHRcdFx0Ly8gV2Ugd2FpdCBvbmUgdGljayB0byBsZXQgcG9zc2libGUgY2hpbGQgc2xvdCBlbGVtZW50cyBiZSBjcmVhdGVkL21vdW50ZWRcblx0XHRcdFx0YXdhaXQgUHJvbWlzZS5yZXNvbHZlKCk7XG5cdFx0XHRcdGlmICghdGhpcy4kJGNuIHx8IHRoaXMuJCRjKSB7XG5cdFx0XHRcdFx0cmV0dXJuO1xuXHRcdFx0XHR9XG5cdFx0XHRcdC8qKiBAcGFyYW0ge3N0cmluZ30gbmFtZSAqL1xuXHRcdFx0XHRmdW5jdGlvbiBjcmVhdGVfc2xvdChuYW1lKSB7XG5cdFx0XHRcdFx0LyoqXG5cdFx0XHRcdFx0ICogQHBhcmFtIHtFbGVtZW50fSBhbmNob3Jcblx0XHRcdFx0XHQgKi9cblx0XHRcdFx0XHRyZXR1cm4gKGFuY2hvcikgPT4ge1xuXHRcdFx0XHRcdFx0Y29uc3Qgc2xvdCA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ3Nsb3QnKTtcblx0XHRcdFx0XHRcdGlmIChuYW1lICE9PSAnZGVmYXVsdCcpIHNsb3QubmFtZSA9IG5hbWU7XG5cblx0XHRcdFx0XHRcdGFwcGVuZChhbmNob3IsIHNsb3QpO1xuXHRcdFx0XHRcdH07XG5cdFx0XHRcdH1cblx0XHRcdFx0LyoqIEB0eXBlIHtSZWNvcmQ8c3RyaW5nLCBhbnk+fSAqL1xuXHRcdFx0XHRjb25zdCAkJHNsb3RzID0ge307XG5cdFx0XHRcdGNvbnN0IGV4aXN0aW5nX3Nsb3RzID0gZ2V0X2N1c3RvbV9lbGVtZW50c19zbG90cyh0aGlzKTtcblx0XHRcdFx0Zm9yIChjb25zdCBuYW1lIG9mIHRoaXMuJCRzKSB7XG5cdFx0XHRcdFx0aWYgKG5hbWUgaW4gZXhpc3Rpbmdfc2xvdHMpIHtcblx0XHRcdFx0XHRcdGlmIChuYW1lID09PSAnZGVmYXVsdCcgJiYgIXRoaXMuJCRkLmNoaWxkcmVuKSB7XG5cdFx0XHRcdFx0XHRcdHRoaXMuJCRkLmNoaWxkcmVuID0gY3JlYXRlX3Nsb3QobmFtZSk7XG5cdFx0XHRcdFx0XHRcdCQkc2xvdHMuZGVmYXVsdCA9IHRydWU7XG5cdFx0XHRcdFx0XHR9IGVsc2Uge1xuXHRcdFx0XHRcdFx0XHQkJHNsb3RzW25hbWVdID0gY3JlYXRlX3Nsb3QobmFtZSk7XG5cdFx0XHRcdFx0XHR9XG5cdFx0XHRcdFx0fVxuXHRcdFx0XHR9XG5cdFx0XHRcdGZvciAoY29uc3QgYXR0cmlidXRlIG9mIHRoaXMuYXR0cmlidXRlcykge1xuXHRcdFx0XHRcdC8vIHRoaXMuJCRkYXRhIHRha2VzIHByZWNlZGVuY2Ugb3ZlciB0aGlzLmF0dHJpYnV0ZXNcblx0XHRcdFx0XHRjb25zdCBuYW1lID0gdGhpcy4kJGdfcChhdHRyaWJ1dGUubmFtZSk7XG5cdFx0XHRcdFx0aWYgKCEobmFtZSBpbiB0aGlzLiQkZCkpIHtcblx0XHRcdFx0XHRcdHRoaXMuJCRkW25hbWVdID0gZ2V0X2N1c3RvbV9lbGVtZW50X3ZhbHVlKG5hbWUsIGF0dHJpYnV0ZS52YWx1ZSwgdGhpcy4kJHBfZCwgJ3RvUHJvcCcpO1xuXHRcdFx0XHRcdH1cblx0XHRcdFx0fVxuXHRcdFx0XHQvLyBQb3J0IG92ZXIgcHJvcHMgdGhhdCB3ZXJlIHNldCBwcm9ncmFtbWF0aWNhbGx5IGJlZm9yZSBjZSB3YXMgaW5pdGlhbGl6ZWRcblx0XHRcdFx0Zm9yIChjb25zdCBrZXkgaW4gdGhpcy4kJHBfZCkge1xuXHRcdFx0XHRcdC8vIEB0cy1leHBlY3QtZXJyb3Jcblx0XHRcdFx0XHRpZiAoIShrZXkgaW4gdGhpcy4kJGQpICYmIHRoaXNba2V5XSAhPT0gdW5kZWZpbmVkKSB7XG5cdFx0XHRcdFx0XHQvLyBAdHMtZXhwZWN0LWVycm9yXG5cdFx0XHRcdFx0XHR0aGlzLiQkZFtrZXldID0gdGhpc1trZXldOyAvLyBkb24ndCB0cmFuc2Zvcm0sIHRoZXNlIHdlcmUgc2V0IHRocm91Z2ggSmF2YVNjcmlwdFxuXHRcdFx0XHRcdFx0Ly8gQHRzLWV4cGVjdC1lcnJvclxuXHRcdFx0XHRcdFx0ZGVsZXRlIHRoaXNba2V5XTsgLy8gcmVtb3ZlIHRoZSBwcm9wZXJ0eSB0aGF0IHNoYWRvd3MgdGhlIGdldHRlci9zZXR0ZXJcblx0XHRcdFx0XHR9XG5cdFx0XHRcdH1cblx0XHRcdFx0dGhpcy4kJGMgPSBjcmVhdGVDbGFzc0NvbXBvbmVudCh7XG5cdFx0XHRcdFx0Y29tcG9uZW50OiB0aGlzLiQkY3Rvcixcblx0XHRcdFx0XHR0YXJnZXQ6IHRoaXMuc2hhZG93Um9vdCB8fCB0aGlzLFxuXHRcdFx0XHRcdHByb3BzOiB7XG5cdFx0XHRcdFx0XHQuLi50aGlzLiQkZCxcblx0XHRcdFx0XHRcdCQkc2xvdHMsXG5cdFx0XHRcdFx0XHQkJGhvc3Q6IHRoaXNcblx0XHRcdFx0XHR9XG5cdFx0XHRcdH0pO1xuXG5cdFx0XHRcdC8vIFJlZmxlY3QgY29tcG9uZW50IHByb3BzIGFzIGF0dHJpYnV0ZXNcblx0XHRcdFx0dGhpcy4kJG1lID0gZWZmZWN0X3Jvb3QoKCkgPT4ge1xuXHRcdFx0XHRcdHJlbmRlcl9lZmZlY3QoKCkgPT4ge1xuXHRcdFx0XHRcdFx0dGhpcy4kJHIgPSB0cnVlO1xuXHRcdFx0XHRcdFx0Zm9yIChjb25zdCBrZXkgb2Ygb2JqZWN0X2tleXModGhpcy4kJGMpKSB7XG5cdFx0XHRcdFx0XHRcdGlmICghdGhpcy4kJHBfZFtrZXldPy5yZWZsZWN0KSBjb250aW51ZTtcblx0XHRcdFx0XHRcdFx0dGhpcy4kJGRba2V5XSA9IHRoaXMuJCRjW2tleV07XG5cdFx0XHRcdFx0XHRcdGNvbnN0IGF0dHJpYnV0ZV92YWx1ZSA9IGdldF9jdXN0b21fZWxlbWVudF92YWx1ZShcblx0XHRcdFx0XHRcdFx0XHRrZXksXG5cdFx0XHRcdFx0XHRcdFx0dGhpcy4kJGRba2V5XSxcblx0XHRcdFx0XHRcdFx0XHR0aGlzLiQkcF9kLFxuXHRcdFx0XHRcdFx0XHRcdCd0b0F0dHJpYnV0ZSdcblx0XHRcdFx0XHRcdFx0KTtcblx0XHRcdFx0XHRcdFx0aWYgKGF0dHJpYnV0ZV92YWx1ZSA9PSBudWxsKSB7XG5cdFx0XHRcdFx0XHRcdFx0dGhpcy5yZW1vdmVBdHRyaWJ1dGUodGhpcy4kJHBfZFtrZXldLmF0dHJpYnV0ZSB8fCBrZXkpO1xuXHRcdFx0XHRcdFx0XHR9IGVsc2Uge1xuXHRcdFx0XHRcdFx0XHRcdHRoaXMuc2V0QXR0cmlidXRlKHRoaXMuJCRwX2Rba2V5XS5hdHRyaWJ1dGUgfHwga2V5LCBhdHRyaWJ1dGVfdmFsdWUpO1xuXHRcdFx0XHRcdFx0XHR9XG5cdFx0XHRcdFx0XHR9XG5cdFx0XHRcdFx0XHR0aGlzLiQkciA9IGZhbHNlO1xuXHRcdFx0XHRcdH0pO1xuXHRcdFx0XHR9KTtcblxuXHRcdFx0XHRmb3IgKGNvbnN0IHR5cGUgaW4gdGhpcy4kJGwpIHtcblx0XHRcdFx0XHRmb3IgKGNvbnN0IGxpc3RlbmVyIG9mIHRoaXMuJCRsW3R5cGVdKSB7XG5cdFx0XHRcdFx0XHRjb25zdCB1bnN1YiA9IHRoaXMuJCRjLiRvbih0eXBlLCBsaXN0ZW5lcik7XG5cdFx0XHRcdFx0XHR0aGlzLiQkbF91LnNldChsaXN0ZW5lciwgdW5zdWIpO1xuXHRcdFx0XHRcdH1cblx0XHRcdFx0fVxuXHRcdFx0XHR0aGlzLiQkbCA9IHt9O1xuXHRcdFx0fVxuXHRcdH1cblxuXHRcdC8vIFdlIGRvbid0IG5lZWQgdGhpcyB3aGVuIHdvcmtpbmcgd2l0aGluIFN2ZWx0ZSBjb2RlLCBidXQgZm9yIGNvbXBhdGliaWxpdHkgb2YgcGVvcGxlIHVzaW5nIHRoaXMgb3V0c2lkZSBvZiBTdmVsdGVcblx0XHQvLyBhbmQgc2V0dGluZyBhdHRyaWJ1dGVzIHRocm91Z2ggc2V0QXR0cmlidXRlIGV0YywgdGhpcyBpcyBoZWxwZnVsXG5cblx0XHQvKipcblx0XHQgKiBAcGFyYW0ge3N0cmluZ30gYXR0clxuXHRcdCAqIEBwYXJhbSB7c3RyaW5nfSBfb2xkVmFsdWVcblx0XHQgKiBAcGFyYW0ge3N0cmluZ30gbmV3VmFsdWVcblx0XHQgKi9cblx0XHRhdHRyaWJ1dGVDaGFuZ2VkQ2FsbGJhY2soYXR0ciwgX29sZFZhbHVlLCBuZXdWYWx1ZSkge1xuXHRcdFx0aWYgKHRoaXMuJCRyKSByZXR1cm47XG5cdFx0XHRhdHRyID0gdGhpcy4kJGdfcChhdHRyKTtcblx0XHRcdHRoaXMuJCRkW2F0dHJdID0gZ2V0X2N1c3RvbV9lbGVtZW50X3ZhbHVlKGF0dHIsIG5ld1ZhbHVlLCB0aGlzLiQkcF9kLCAndG9Qcm9wJyk7XG5cdFx0XHR0aGlzLiQkYz8uJHNldCh7IFthdHRyXTogdGhpcy4kJGRbYXR0cl0gfSk7XG5cdFx0fVxuXG5cdFx0ZGlzY29ubmVjdGVkQ2FsbGJhY2soKSB7XG5cdFx0XHR0aGlzLiQkY24gPSBmYWxzZTtcblx0XHRcdC8vIEluIGEgbWljcm90YXNrLCBiZWNhdXNlIHRoaXMgY291bGQgYmUgYSBtb3ZlIHdpdGhpbiB0aGUgRE9NXG5cdFx0XHRQcm9taXNlLnJlc29sdmUoKS50aGVuKCgpID0+IHtcblx0XHRcdFx0aWYgKCF0aGlzLiQkY24gJiYgdGhpcy4kJGMpIHtcblx0XHRcdFx0XHR0aGlzLiQkYy4kZGVzdHJveSgpO1xuXHRcdFx0XHRcdHRoaXMuJCRtZSgpO1xuXHRcdFx0XHRcdHRoaXMuJCRjID0gdW5kZWZpbmVkO1xuXHRcdFx0XHR9XG5cdFx0XHR9KTtcblx0XHR9XG5cblx0XHQvKipcblx0XHQgKiBAcGFyYW0ge3N0cmluZ30gYXR0cmlidXRlX25hbWVcblx0XHQgKi9cblx0XHQkJGdfcChhdHRyaWJ1dGVfbmFtZSkge1xuXHRcdFx0cmV0dXJuIChcblx0XHRcdFx0b2JqZWN0X2tleXModGhpcy4kJHBfZCkuZmluZChcblx0XHRcdFx0XHQoa2V5KSA9PlxuXHRcdFx0XHRcdFx0dGhpcy4kJHBfZFtrZXldLmF0dHJpYnV0ZSA9PT0gYXR0cmlidXRlX25hbWUgfHxcblx0XHRcdFx0XHRcdCghdGhpcy4kJHBfZFtrZXldLmF0dHJpYnV0ZSAmJiBrZXkudG9Mb3dlckNhc2UoKSA9PT0gYXR0cmlidXRlX25hbWUpXG5cdFx0XHRcdCkgfHwgYXR0cmlidXRlX25hbWVcblx0XHRcdCk7XG5cdFx0fVxuXHR9O1xufVxuXG4vKipcbiAqIEBwYXJhbSB7c3RyaW5nfSBwcm9wXG4gKiBAcGFyYW0ge2FueX0gdmFsdWVcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgQ3VzdG9tRWxlbWVudFByb3BEZWZpbml0aW9uPn0gcHJvcHNfZGVmaW5pdGlvblxuICogQHBhcmFtIHsndG9BdHRyaWJ1dGUnIHwgJ3RvUHJvcCd9IFt0cmFuc2Zvcm1dXG4gKi9cbmZ1bmN0aW9uIGdldF9jdXN0b21fZWxlbWVudF92YWx1ZShwcm9wLCB2YWx1ZSwgcHJvcHNfZGVmaW5pdGlvbiwgdHJhbnNmb3JtKSB7XG5cdGNvbnN0IHR5cGUgPSBwcm9wc19kZWZpbml0aW9uW3Byb3BdPy50eXBlO1xuXHR2YWx1ZSA9IHR5cGUgPT09ICdCb29sZWFuJyAmJiB0eXBlb2YgdmFsdWUgIT09ICdib29sZWFuJyA/IHZhbHVlICE9IG51bGwgOiB2YWx1ZTtcblx0aWYgKCF0cmFuc2Zvcm0gfHwgIXByb3BzX2RlZmluaXRpb25bcHJvcF0pIHtcblx0XHRyZXR1cm4gdmFsdWU7XG5cdH0gZWxzZSBpZiAodHJhbnNmb3JtID09PSAndG9BdHRyaWJ1dGUnKSB7XG5cdFx0c3dpdGNoICh0eXBlKSB7XG5cdFx0XHRjYXNlICdPYmplY3QnOlxuXHRcdFx0Y2FzZSAnQXJyYXknOlxuXHRcdFx0XHRyZXR1cm4gdmFsdWUgPT0gbnVsbCA/IG51bGwgOiBKU09OLnN0cmluZ2lmeSh2YWx1ZSk7XG5cdFx0XHRjYXNlICdCb29sZWFuJzpcblx0XHRcdFx0cmV0dXJuIHZhbHVlID8gJycgOiBudWxsO1xuXHRcdFx0Y2FzZSAnTnVtYmVyJzpcblx0XHRcdFx0cmV0dXJuIHZhbHVlID09IG51bGwgPyBudWxsIDogdmFsdWU7XG5cdFx0XHRkZWZhdWx0OlxuXHRcdFx0XHRyZXR1cm4gdmFsdWU7XG5cdFx0fVxuXHR9IGVsc2Uge1xuXHRcdHN3aXRjaCAodHlwZSkge1xuXHRcdFx0Y2FzZSAnT2JqZWN0Jzpcblx0XHRcdGNhc2UgJ0FycmF5Jzpcblx0XHRcdFx0cmV0dXJuIHZhbHVlICYmIEpTT04ucGFyc2UodmFsdWUpO1xuXHRcdFx0Y2FzZSAnQm9vbGVhbic6XG5cdFx0XHRcdHJldHVybiB2YWx1ZTsgLy8gY29udmVyc2lvbiBhbHJlYWR5IGhhbmRsZWQgYWJvdmVcblx0XHRcdGNhc2UgJ051bWJlcic6XG5cdFx0XHRcdHJldHVybiB2YWx1ZSAhPSBudWxsID8gK3ZhbHVlIDogdmFsdWU7XG5cdFx0XHRkZWZhdWx0OlxuXHRcdFx0XHRyZXR1cm4gdmFsdWU7XG5cdFx0fVxuXHR9XG59XG5cbi8qKlxuICogQHBhcmFtIHtIVE1MRWxlbWVudH0gZWxlbWVudFxuICovXG5mdW5jdGlvbiBnZXRfY3VzdG9tX2VsZW1lbnRzX3Nsb3RzKGVsZW1lbnQpIHtcblx0LyoqIEB0eXBlIHtSZWNvcmQ8c3RyaW5nLCB0cnVlPn0gKi9cblx0Y29uc3QgcmVzdWx0ID0ge307XG5cdGVsZW1lbnQuY2hpbGROb2Rlcy5mb3JFYWNoKChub2RlKSA9PiB7XG5cdFx0cmVzdWx0Wy8qKiBAdHlwZSB7RWxlbWVudH0gbm9kZSAqLyAobm9kZSkuc2xvdCB8fCAnZGVmYXVsdCddID0gdHJ1ZTtcblx0fSk7XG5cdHJldHVybiByZXN1bHQ7XG59XG5cbi8qKlxuICogQGludGVybmFsXG4gKlxuICogVHVybiBhIFN2ZWx0ZSBjb21wb25lbnQgaW50byBhIGN1c3RvbSBlbGVtZW50LlxuICogQHBhcmFtIHthbnl9IENvbXBvbmVudCAgQSBTdmVsdGUgY29tcG9uZW50IGZ1bmN0aW9uXG4gKiBAcGFyYW0ge1JlY29yZDxzdHJpbmcsIEN1c3RvbUVsZW1lbnRQcm9wRGVmaW5pdGlvbj59IHByb3BzX2RlZmluaXRpb24gIFRoZSBwcm9wcyB0byBvYnNlcnZlXG4gKiBAcGFyYW0ge3N0cmluZ1tdfSBzbG90cyAgVGhlIHNsb3RzIHRvIGNyZWF0ZVxuICogQHBhcmFtIHtzdHJpbmdbXX0gZXhwb3J0cyAgRXhwbGljaXRseSBleHBvcnRlZCB2YWx1ZXMsIG90aGVyIHRoYW4gcHJvcHNcbiAqIEBwYXJhbSB7Ym9vbGVhbn0gdXNlX3NoYWRvd19kb20gIFdoZXRoZXIgdG8gdXNlIHNoYWRvdyBET01cbiAqIEBwYXJhbSB7KGNlOiBuZXcgKCkgPT4gSFRNTEVsZW1lbnQpID0+IG5ldyAoKSA9PiBIVE1MRWxlbWVudH0gW2V4dGVuZF1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGNyZWF0ZV9jdXN0b21fZWxlbWVudChcblx0Q29tcG9uZW50LFxuXHRwcm9wc19kZWZpbml0aW9uLFxuXHRzbG90cyxcblx0ZXhwb3J0cyxcblx0dXNlX3NoYWRvd19kb20sXG5cdGV4dGVuZFxuKSB7XG5cdGxldCBDbGFzcyA9IGNsYXNzIGV4dGVuZHMgU3ZlbHRlRWxlbWVudCB7XG5cdFx0Y29uc3RydWN0b3IoKSB7XG5cdFx0XHRzdXBlcihDb21wb25lbnQsIHNsb3RzLCB1c2Vfc2hhZG93X2RvbSk7XG5cdFx0XHR0aGlzLiQkcF9kID0gcHJvcHNfZGVmaW5pdGlvbjtcblx0XHR9XG5cdFx0c3RhdGljIGdldCBvYnNlcnZlZEF0dHJpYnV0ZXMoKSB7XG5cdFx0XHRyZXR1cm4gb2JqZWN0X2tleXMocHJvcHNfZGVmaW5pdGlvbikubWFwKChrZXkpID0+XG5cdFx0XHRcdChwcm9wc19kZWZpbml0aW9uW2tleV0uYXR0cmlidXRlIHx8IGtleSkudG9Mb3dlckNhc2UoKVxuXHRcdFx0KTtcblx0XHR9XG5cdH07XG5cdG9iamVjdF9rZXlzKHByb3BzX2RlZmluaXRpb24pLmZvckVhY2goKHByb3ApID0+IHtcblx0XHRkZWZpbmVfcHJvcGVydHkoQ2xhc3MucHJvdG90eXBlLCBwcm9wLCB7XG5cdFx0XHRnZXQoKSB7XG5cdFx0XHRcdHJldHVybiB0aGlzLiQkYyAmJiBwcm9wIGluIHRoaXMuJCRjID8gdGhpcy4kJGNbcHJvcF0gOiB0aGlzLiQkZFtwcm9wXTtcblx0XHRcdH0sXG5cdFx0XHRzZXQodmFsdWUpIHtcblx0XHRcdFx0dmFsdWUgPSBnZXRfY3VzdG9tX2VsZW1lbnRfdmFsdWUocHJvcCwgdmFsdWUsIHByb3BzX2RlZmluaXRpb24pO1xuXHRcdFx0XHR0aGlzLiQkZFtwcm9wXSA9IHZhbHVlO1xuXHRcdFx0XHR2YXIgY29tcG9uZW50ID0gdGhpcy4kJGM7XG5cblx0XHRcdFx0aWYgKGNvbXBvbmVudCkge1xuXHRcdFx0XHRcdC8vIC8vIElmIHRoZSBpbnN0YW5jZSBoYXMgYW4gYWNjZXNzb3IsIHVzZSB0aGF0IGluc3RlYWRcblx0XHRcdFx0XHR2YXIgc2V0dGVyID0gZ2V0X2Rlc2NyaXB0b3IoY29tcG9uZW50LCBwcm9wKT8uZ2V0O1xuXG5cdFx0XHRcdFx0aWYgKHNldHRlcikge1xuXHRcdFx0XHRcdFx0Y29tcG9uZW50W3Byb3BdID0gdmFsdWU7XG5cdFx0XHRcdFx0fSBlbHNlIHtcblx0XHRcdFx0XHRcdGNvbXBvbmVudC4kc2V0KHsgW3Byb3BdOiB2YWx1ZSB9KTtcblx0XHRcdFx0XHR9XG5cdFx0XHRcdH1cblx0XHRcdH1cblx0XHR9KTtcblx0fSk7XG5cdGV4cG9ydHMuZm9yRWFjaCgocHJvcGVydHkpID0+IHtcblx0XHRkZWZpbmVfcHJvcGVydHkoQ2xhc3MucHJvdG90eXBlLCBwcm9wZXJ0eSwge1xuXHRcdFx0Z2V0KCkge1xuXHRcdFx0XHRyZXR1cm4gdGhpcy4kJGM/Lltwcm9wZXJ0eV07XG5cdFx0XHR9XG5cdFx0fSk7XG5cdH0pO1xuXHRpZiAoZXh0ZW5kKSB7XG5cdFx0Ly8gQHRzLWV4cGVjdC1lcnJvciAtIGFzc2lnbmluZyBoZXJlIGlzIGZpbmVcblx0XHRDbGFzcyA9IGV4dGVuZChDbGFzcyk7XG5cdH1cblx0Q29tcG9uZW50LmVsZW1lbnQgPSAvKiogQHR5cGUge2FueX0gKi8gQ2xhc3M7XG5cdHJldHVybiBDbGFzcztcbn1cbiIsICIvKiogQGltcG9ydCB7IENvbXBvbmVudENvbnRleHQsIENvbXBvbmVudENvbnRleHRMZWdhY3kgfSBmcm9tICcjY2xpZW50JyAqL1xuLyoqIEBpbXBvcnQgeyBFdmVudERpc3BhdGNoZXIgfSBmcm9tICcuL2luZGV4LmpzJyAqL1xuLyoqIEBpbXBvcnQgeyBOb3RGdW5jdGlvbiB9IGZyb20gJy4vaW50ZXJuYWwvdHlwZXMuanMnICovXG5pbXBvcnQgeyBmbHVzaF9zeW5jLCB1bnRyYWNrIH0gZnJvbSAnLi9pbnRlcm5hbC9jbGllbnQvcnVudGltZS5qcyc7XG5pbXBvcnQgeyBpc19hcnJheSB9IGZyb20gJy4vaW50ZXJuYWwvc2hhcmVkL3V0aWxzLmpzJztcbmltcG9ydCB7IHVzZXJfZWZmZWN0IH0gZnJvbSAnLi9pbnRlcm5hbC9jbGllbnQvaW5kZXguanMnO1xuaW1wb3J0ICogYXMgZSBmcm9tICcuL2ludGVybmFsL2NsaWVudC9lcnJvcnMuanMnO1xuaW1wb3J0IHsgbGlmZWN5Y2xlX291dHNpZGVfY29tcG9uZW50IH0gZnJvbSAnLi9pbnRlcm5hbC9zaGFyZWQvZXJyb3JzLmpzJztcbmltcG9ydCB7IGxlZ2FjeV9tb2RlX2ZsYWcgfSBmcm9tICcuL2ludGVybmFsL2ZsYWdzL2luZGV4LmpzJztcbmltcG9ydCB7IGNvbXBvbmVudF9jb250ZXh0IH0gZnJvbSAnLi9pbnRlcm5hbC9jbGllbnQvY29udGV4dC5qcyc7XG5pbXBvcnQgeyBERVYgfSBmcm9tICdlc20tZW52JztcblxuaWYgKERFVikge1xuXHQvKipcblx0ICogQHBhcmFtIHtzdHJpbmd9IHJ1bmVcblx0ICovXG5cdGZ1bmN0aW9uIHRocm93X3J1bmVfZXJyb3IocnVuZSkge1xuXHRcdGlmICghKHJ1bmUgaW4gZ2xvYmFsVGhpcykpIHtcblx0XHRcdC8vIFRPRE8gaWYgcGVvcGxlIHN0YXJ0IGFkanVzdGluZyB0aGUgXCJ0aGlzIGNhbiBjb250YWluIHJ1bmVzXCIgY29uZmlnIHRocm91Z2ggdi1wLXMgbW9yZSwgYWRqdXN0IHRoaXMgbWVzc2FnZVxuXHRcdFx0LyoqIEB0eXBlIHthbnl9ICovXG5cdFx0XHRsZXQgdmFsdWU7IC8vIGxldCdzIGhvcGUgbm9vbmUgbW9kaWZpZXMgdGhpcyBnbG9iYWwsIGJ1dCBiZWx0cyBhbmQgYnJhY2VzXG5cdFx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZ2xvYmFsVGhpcywgcnVuZSwge1xuXHRcdFx0XHRjb25maWd1cmFibGU6IHRydWUsXG5cdFx0XHRcdC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBnZXR0ZXItcmV0dXJuXG5cdFx0XHRcdGdldDogKCkgPT4ge1xuXHRcdFx0XHRcdGlmICh2YWx1ZSAhPT0gdW5kZWZpbmVkKSB7XG5cdFx0XHRcdFx0XHRyZXR1cm4gdmFsdWU7XG5cdFx0XHRcdFx0fVxuXG5cdFx0XHRcdFx0ZS5ydW5lX291dHNpZGVfc3ZlbHRlKHJ1bmUpO1xuXHRcdFx0XHR9LFxuXHRcdFx0XHRzZXQ6ICh2KSA9PiB7XG5cdFx0XHRcdFx0dmFsdWUgPSB2O1xuXHRcdFx0XHR9XG5cdFx0XHR9KTtcblx0XHR9XG5cdH1cblxuXHR0aHJvd19ydW5lX2Vycm9yKCckc3RhdGUnKTtcblx0dGhyb3dfcnVuZV9lcnJvcignJGVmZmVjdCcpO1xuXHR0aHJvd19ydW5lX2Vycm9yKCckZGVyaXZlZCcpO1xuXHR0aHJvd19ydW5lX2Vycm9yKCckaW5zcGVjdCcpO1xuXHR0aHJvd19ydW5lX2Vycm9yKCckcHJvcHMnKTtcblx0dGhyb3dfcnVuZV9lcnJvcignJGJpbmRhYmxlJyk7XG59XG5cbi8qKlxuICogVGhlIGBvbk1vdW50YCBmdW5jdGlvbiBzY2hlZHVsZXMgYSBjYWxsYmFjayB0byBydW4gYXMgc29vbiBhcyB0aGUgY29tcG9uZW50IGhhcyBiZWVuIG1vdW50ZWQgdG8gdGhlIERPTS5cbiAqIEl0IG11c3QgYmUgY2FsbGVkIGR1cmluZyB0aGUgY29tcG9uZW50J3MgaW5pdGlhbGlzYXRpb24gKGJ1dCBkb2Vzbid0IG5lZWQgdG8gbGl2ZSAqaW5zaWRlKiB0aGUgY29tcG9uZW50O1xuICogaXQgY2FuIGJlIGNhbGxlZCBmcm9tIGFuIGV4dGVybmFsIG1vZHVsZSkuXG4gKlxuICogSWYgYSBmdW5jdGlvbiBpcyByZXR1cm5lZCBfc3luY2hyb25vdXNseV8gZnJvbSBgb25Nb3VudGAsIGl0IHdpbGwgYmUgY2FsbGVkIHdoZW4gdGhlIGNvbXBvbmVudCBpcyB1bm1vdW50ZWQuXG4gKlxuICogYG9uTW91bnRgIGRvZXMgbm90IHJ1biBpbnNpZGUgW3NlcnZlci1zaWRlIGNvbXBvbmVudHNdKGh0dHBzOi8vc3ZlbHRlLmRldi9kb2NzL3N2ZWx0ZS9zdmVsdGUtc2VydmVyI3JlbmRlcikuXG4gKlxuICogQHRlbXBsYXRlIFRcbiAqIEBwYXJhbSB7KCkgPT4gTm90RnVuY3Rpb248VD4gfCBQcm9taXNlPE5vdEZ1bmN0aW9uPFQ+PiB8ICgoKSA9PiBhbnkpfSBmblxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBvbk1vdW50KGZuKSB7XG5cdGlmIChjb21wb25lbnRfY29udGV4dCA9PT0gbnVsbCkge1xuXHRcdGxpZmVjeWNsZV9vdXRzaWRlX2NvbXBvbmVudCgnb25Nb3VudCcpO1xuXHR9XG5cblx0aWYgKGxlZ2FjeV9tb2RlX2ZsYWcgJiYgY29tcG9uZW50X2NvbnRleHQubCAhPT0gbnVsbCkge1xuXHRcdGluaXRfdXBkYXRlX2NhbGxiYWNrcyhjb21wb25lbnRfY29udGV4dCkubS5wdXNoKGZuKTtcblx0fSBlbHNlIHtcblx0XHR1c2VyX2VmZmVjdCgoKSA9PiB7XG5cdFx0XHRjb25zdCBjbGVhbnVwID0gdW50cmFjayhmbik7XG5cdFx0XHRpZiAodHlwZW9mIGNsZWFudXAgPT09ICdmdW5jdGlvbicpIHJldHVybiAvKiogQHR5cGUgeygpID0+IHZvaWR9ICovIChjbGVhbnVwKTtcblx0XHR9KTtcblx0fVxufVxuXG4vKipcbiAqIFNjaGVkdWxlcyBhIGNhbGxiYWNrIHRvIHJ1biBpbW1lZGlhdGVseSBiZWZvcmUgdGhlIGNvbXBvbmVudCBpcyB1bm1vdW50ZWQuXG4gKlxuICogT3V0IG9mIGBvbk1vdW50YCwgYGJlZm9yZVVwZGF0ZWAsIGBhZnRlclVwZGF0ZWAgYW5kIGBvbkRlc3Ryb3lgLCB0aGlzIGlzIHRoZVxuICogb25seSBvbmUgdGhhdCBydW5zIGluc2lkZSBhIHNlcnZlci1zaWRlIGNvbXBvbmVudC5cbiAqXG4gKiBAcGFyYW0geygpID0+IGFueX0gZm5cbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gb25EZXN0cm95KGZuKSB7XG5cdGlmIChjb21wb25lbnRfY29udGV4dCA9PT0gbnVsbCkge1xuXHRcdGxpZmVjeWNsZV9vdXRzaWRlX2NvbXBvbmVudCgnb25EZXN0cm95Jyk7XG5cdH1cblxuXHRvbk1vdW50KCgpID0+ICgpID0+IHVudHJhY2soZm4pKTtcbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUgW1Q9YW55XVxuICogQHBhcmFtIHtzdHJpbmd9IHR5cGVcbiAqIEBwYXJhbSB7VH0gW2RldGFpbF1cbiAqIEBwYXJhbSB7YW55fXBhcmFtc18wXG4gKiBAcmV0dXJucyB7Q3VzdG9tRXZlbnQ8VD59XG4gKi9cbmZ1bmN0aW9uIGNyZWF0ZV9jdXN0b21fZXZlbnQodHlwZSwgZGV0YWlsLCB7IGJ1YmJsZXMgPSBmYWxzZSwgY2FuY2VsYWJsZSA9IGZhbHNlIH0gPSB7fSkge1xuXHRyZXR1cm4gbmV3IEN1c3RvbUV2ZW50KHR5cGUsIHsgZGV0YWlsLCBidWJibGVzLCBjYW5jZWxhYmxlIH0pO1xufVxuXG4vKipcbiAqIENyZWF0ZXMgYW4gZXZlbnQgZGlzcGF0Y2hlciB0aGF0IGNhbiBiZSB1c2VkIHRvIGRpc3BhdGNoIFtjb21wb25lbnQgZXZlbnRzXShodHRwczovL3N2ZWx0ZS5kZXYvZG9jcy9zdmVsdGUvbGVnYWN5LW9uI0NvbXBvbmVudC1ldmVudHMpLlxuICogRXZlbnQgZGlzcGF0Y2hlcnMgYXJlIGZ1bmN0aW9ucyB0aGF0IGNhbiB0YWtlIHR3byBhcmd1bWVudHM6IGBuYW1lYCBhbmQgYGRldGFpbGAuXG4gKlxuICogQ29tcG9uZW50IGV2ZW50cyBjcmVhdGVkIHdpdGggYGNyZWF0ZUV2ZW50RGlzcGF0Y2hlcmAgY3JlYXRlIGFcbiAqIFtDdXN0b21FdmVudF0oaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4tVVMvZG9jcy9XZWIvQVBJL0N1c3RvbUV2ZW50KS5cbiAqIFRoZXNlIGV2ZW50cyBkbyBub3QgW2J1YmJsZV0oaHR0cHM6Ly9kZXZlbG9wZXIubW96aWxsYS5vcmcvZW4tVVMvZG9jcy9MZWFybi9KYXZhU2NyaXB0L0J1aWxkaW5nX2Jsb2Nrcy9FdmVudHMjRXZlbnRfYnViYmxpbmdfYW5kX2NhcHR1cmUpLlxuICogVGhlIGBkZXRhaWxgIGFyZ3VtZW50IGNvcnJlc3BvbmRzIHRvIHRoZSBbQ3VzdG9tRXZlbnQuZGV0YWlsXShodHRwczovL2RldmVsb3Blci5tb3ppbGxhLm9yZy9lbi1VUy9kb2NzL1dlYi9BUEkvQ3VzdG9tRXZlbnQvZGV0YWlsKVxuICogcHJvcGVydHkgYW5kIGNhbiBjb250YWluIGFueSB0eXBlIG9mIGRhdGEuXG4gKlxuICogVGhlIGV2ZW50IGRpc3BhdGNoZXIgY2FuIGJlIHR5cGVkIHRvIG5hcnJvdyB0aGUgYWxsb3dlZCBldmVudCBuYW1lcyBhbmQgdGhlIHR5cGUgb2YgdGhlIGBkZXRhaWxgIGFyZ3VtZW50OlxuICogYGBgdHNcbiAqIGNvbnN0IGRpc3BhdGNoID0gY3JlYXRlRXZlbnREaXNwYXRjaGVyPHtcbiAqICBsb2FkZWQ6IG5ldmVyOyAvLyBkb2VzIG5vdCB0YWtlIGEgZGV0YWlsIGFyZ3VtZW50XG4gKiAgY2hhbmdlOiBzdHJpbmc7IC8vIHRha2VzIGEgZGV0YWlsIGFyZ3VtZW50IG9mIHR5cGUgc3RyaW5nLCB3aGljaCBpcyByZXF1aXJlZFxuICogIG9wdGlvbmFsOiBudW1iZXIgfCBudWxsOyAvLyB0YWtlcyBhbiBvcHRpb25hbCBkZXRhaWwgYXJndW1lbnQgb2YgdHlwZSBudW1iZXJcbiAqIH0+KCk7XG4gKiBgYGBcbiAqXG4gKiBAZGVwcmVjYXRlZCBVc2UgY2FsbGJhY2sgcHJvcHMgYW5kL29yIHRoZSBgJGhvc3QoKWAgcnVuZSBpbnN0ZWFkIFx1MjAxNCBzZWUgW21pZ3JhdGlvbiBndWlkZV0oaHR0cHM6Ly9zdmVsdGUuZGV2L2RvY3Mvc3ZlbHRlL3Y1LW1pZ3JhdGlvbi1ndWlkZSNFdmVudC1jaGFuZ2VzLUNvbXBvbmVudC1ldmVudHMpXG4gKiBAdGVtcGxhdGUge1JlY29yZDxzdHJpbmcsIGFueT59IFtFdmVudE1hcCA9IGFueV1cbiAqIEByZXR1cm5zIHtFdmVudERpc3BhdGNoZXI8RXZlbnRNYXA+fVxuICovXG5leHBvcnQgZnVuY3Rpb24gY3JlYXRlRXZlbnREaXNwYXRjaGVyKCkge1xuXHRjb25zdCBhY3RpdmVfY29tcG9uZW50X2NvbnRleHQgPSBjb21wb25lbnRfY29udGV4dDtcblx0aWYgKGFjdGl2ZV9jb21wb25lbnRfY29udGV4dCA9PT0gbnVsbCkge1xuXHRcdGxpZmVjeWNsZV9vdXRzaWRlX2NvbXBvbmVudCgnY3JlYXRlRXZlbnREaXNwYXRjaGVyJyk7XG5cdH1cblxuXHRyZXR1cm4gKHR5cGUsIGRldGFpbCwgb3B0aW9ucykgPT4ge1xuXHRcdGNvbnN0IGV2ZW50cyA9IC8qKiBAdHlwZSB7UmVjb3JkPHN0cmluZywgRnVuY3Rpb24gfCBGdW5jdGlvbltdPn0gKi8gKFxuXHRcdFx0YWN0aXZlX2NvbXBvbmVudF9jb250ZXh0LnMuJCRldmVudHNcblx0XHQpPy5bLyoqIEB0eXBlIHthbnl9ICovICh0eXBlKV07XG5cblx0XHRpZiAoZXZlbnRzKSB7XG5cdFx0XHRjb25zdCBjYWxsYmFja3MgPSBpc19hcnJheShldmVudHMpID8gZXZlbnRzLnNsaWNlKCkgOiBbZXZlbnRzXTtcblx0XHRcdC8vIFRPRE8gYXJlIHRoZXJlIHNpdHVhdGlvbnMgd2hlcmUgZXZlbnRzIGNvdWxkIGJlIGRpc3BhdGNoZWRcblx0XHRcdC8vIGluIGEgc2VydmVyIChub24tRE9NKSBlbnZpcm9ubWVudD9cblx0XHRcdGNvbnN0IGV2ZW50ID0gY3JlYXRlX2N1c3RvbV9ldmVudCgvKiogQHR5cGUge3N0cmluZ30gKi8gKHR5cGUpLCBkZXRhaWwsIG9wdGlvbnMpO1xuXHRcdFx0Zm9yIChjb25zdCBmbiBvZiBjYWxsYmFja3MpIHtcblx0XHRcdFx0Zm4uY2FsbChhY3RpdmVfY29tcG9uZW50X2NvbnRleHQueCwgZXZlbnQpO1xuXHRcdFx0fVxuXHRcdFx0cmV0dXJuICFldmVudC5kZWZhdWx0UHJldmVudGVkO1xuXHRcdH1cblxuXHRcdHJldHVybiB0cnVlO1xuXHR9O1xufVxuXG4vLyBUT0RPIG1hcmsgYmVmb3JlVXBkYXRlIGFuZCBhZnRlclVwZGF0ZSBhcyBkZXByZWNhdGVkIGluIFN2ZWx0ZSA2XG5cbi8qKlxuICogU2NoZWR1bGVzIGEgY2FsbGJhY2sgdG8gcnVuIGltbWVkaWF0ZWx5IGJlZm9yZSB0aGUgY29tcG9uZW50IGlzIHVwZGF0ZWQgYWZ0ZXIgYW55IHN0YXRlIGNoYW5nZS5cbiAqXG4gKiBUaGUgZmlyc3QgdGltZSB0aGUgY2FsbGJhY2sgcnVucyB3aWxsIGJlIGJlZm9yZSB0aGUgaW5pdGlhbCBgb25Nb3VudGAuXG4gKlxuICogSW4gcnVuZXMgbW9kZSB1c2UgYCRlZmZlY3QucHJlYCBpbnN0ZWFkLlxuICpcbiAqIEBkZXByZWNhdGVkIFVzZSBbYCRlZmZlY3QucHJlYF0oaHR0cHM6Ly9zdmVsdGUuZGV2L2RvY3Mvc3ZlbHRlLyRlZmZlY3QjJGVmZmVjdC5wcmUpIGluc3RlYWRcbiAqIEBwYXJhbSB7KCkgPT4gdm9pZH0gZm5cbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gYmVmb3JlVXBkYXRlKGZuKSB7XG5cdGlmIChjb21wb25lbnRfY29udGV4dCA9PT0gbnVsbCkge1xuXHRcdGxpZmVjeWNsZV9vdXRzaWRlX2NvbXBvbmVudCgnYmVmb3JlVXBkYXRlJyk7XG5cdH1cblxuXHRpZiAoY29tcG9uZW50X2NvbnRleHQubCA9PT0gbnVsbCkge1xuXHRcdGUubGlmZWN5Y2xlX2xlZ2FjeV9vbmx5KCdiZWZvcmVVcGRhdGUnKTtcblx0fVxuXG5cdGluaXRfdXBkYXRlX2NhbGxiYWNrcyhjb21wb25lbnRfY29udGV4dCkuYi5wdXNoKGZuKTtcbn1cblxuLyoqXG4gKiBTY2hlZHVsZXMgYSBjYWxsYmFjayB0byBydW4gaW1tZWRpYXRlbHkgYWZ0ZXIgdGhlIGNvbXBvbmVudCBoYXMgYmVlbiB1cGRhdGVkLlxuICpcbiAqIFRoZSBmaXJzdCB0aW1lIHRoZSBjYWxsYmFjayBydW5zIHdpbGwgYmUgYWZ0ZXIgdGhlIGluaXRpYWwgYG9uTW91bnRgLlxuICpcbiAqIEluIHJ1bmVzIG1vZGUgdXNlIGAkZWZmZWN0YCBpbnN0ZWFkLlxuICpcbiAqIEBkZXByZWNhdGVkIFVzZSBbYCRlZmZlY3RgXShodHRwczovL3N2ZWx0ZS5kZXYvZG9jcy9zdmVsdGUvJGVmZmVjdCkgaW5zdGVhZFxuICogQHBhcmFtIHsoKSA9PiB2b2lkfSBmblxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBhZnRlclVwZGF0ZShmbikge1xuXHRpZiAoY29tcG9uZW50X2NvbnRleHQgPT09IG51bGwpIHtcblx0XHRsaWZlY3ljbGVfb3V0c2lkZV9jb21wb25lbnQoJ2FmdGVyVXBkYXRlJyk7XG5cdH1cblxuXHRpZiAoY29tcG9uZW50X2NvbnRleHQubCA9PT0gbnVsbCkge1xuXHRcdGUubGlmZWN5Y2xlX2xlZ2FjeV9vbmx5KCdhZnRlclVwZGF0ZScpO1xuXHR9XG5cblx0aW5pdF91cGRhdGVfY2FsbGJhY2tzKGNvbXBvbmVudF9jb250ZXh0KS5hLnB1c2goZm4pO1xufVxuXG4vKipcbiAqIExlZ2FjeS1tb2RlOiBJbml0IGNhbGxiYWNrcyBvYmplY3QgZm9yIG9uTW91bnQvYmVmb3JlVXBkYXRlL2FmdGVyVXBkYXRlXG4gKiBAcGFyYW0ge0NvbXBvbmVudENvbnRleHR9IGNvbnRleHRcbiAqL1xuZnVuY3Rpb24gaW5pdF91cGRhdGVfY2FsbGJhY2tzKGNvbnRleHQpIHtcblx0dmFyIGwgPSAvKiogQHR5cGUge0NvbXBvbmVudENvbnRleHRMZWdhY3l9ICovIChjb250ZXh0KS5sO1xuXHRyZXR1cm4gKGwudSA/Pz0geyBhOiBbXSwgYjogW10sIG06IFtdIH0pO1xufVxuXG4vKipcbiAqIFN5bmNocm9ub3VzbHkgZmx1c2hlcyBhbnkgcGVuZGluZyBzdGF0ZSBjaGFuZ2VzIGFuZCB0aG9zZSB0aGF0IHJlc3VsdCBmcm9tIGl0LlxuICogQHBhcmFtIHsoKSA9PiB2b2lkfSBbZm5dXG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGZsdXNoU3luYyhmbikge1xuXHRmbHVzaF9zeW5jKGZuKTtcbn1cblxuZXhwb3J0IHsgZ2V0Q29udGV4dCwgZ2V0QWxsQ29udGV4dHMsIGhhc0NvbnRleHQsIHNldENvbnRleHQgfSBmcm9tICcuL2ludGVybmFsL2NsaWVudC9jb250ZXh0LmpzJztcbmV4cG9ydCB7IGh5ZHJhdGUsIG1vdW50LCB1bm1vdW50IH0gZnJvbSAnLi9pbnRlcm5hbC9jbGllbnQvcmVuZGVyLmpzJztcbmV4cG9ydCB7IHRpY2ssIHVudHJhY2sgfSBmcm9tICcuL2ludGVybmFsL2NsaWVudC9ydW50aW1lLmpzJztcbmV4cG9ydCB7IGNyZWF0ZVJhd1NuaXBwZXQgfSBmcm9tICcuL2ludGVybmFsL2NsaWVudC9kb20vYmxvY2tzL3NuaXBwZXQuanMnO1xuIiwgIi8qKiBAaW1wb3J0IHsgQ29tcG9uZW50IH0gZnJvbSAnI3NlcnZlcicgKi9cbmltcG9ydCB7IERFViB9IGZyb20gJ2VzbS1lbnYnO1xuaW1wb3J0IHsgb25fZGVzdHJveSB9IGZyb20gJy4vaW5kZXguanMnO1xuaW1wb3J0ICogYXMgZSBmcm9tICcuLi9zaGFyZWQvZXJyb3JzLmpzJztcblxuLyoqIEB0eXBlIHtDb21wb25lbnQgfCBudWxsfSAqL1xuZXhwb3J0IHZhciBjdXJyZW50X2NvbXBvbmVudCA9IG51bGw7XG5cbi8qKlxuICogQHRlbXBsYXRlIFRcbiAqIEBwYXJhbSB7YW55fSBrZXlcbiAqIEByZXR1cm5zIHtUfVxuICovXG5leHBvcnQgZnVuY3Rpb24gZ2V0Q29udGV4dChrZXkpIHtcblx0Y29uc3QgY29udGV4dF9tYXAgPSBnZXRfb3JfaW5pdF9jb250ZXh0X21hcCgnZ2V0Q29udGV4dCcpO1xuXHRjb25zdCByZXN1bHQgPSAvKiogQHR5cGUge1R9ICovIChjb250ZXh0X21hcC5nZXQoa2V5KSk7XG5cblx0cmV0dXJuIHJlc3VsdDtcbn1cblxuLyoqXG4gKiBAdGVtcGxhdGUgVFxuICogQHBhcmFtIHthbnl9IGtleVxuICogQHBhcmFtIHtUfSBjb250ZXh0XG4gKiBAcmV0dXJucyB7VH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHNldENvbnRleHQoa2V5LCBjb250ZXh0KSB7XG5cdGdldF9vcl9pbml0X2NvbnRleHRfbWFwKCdzZXRDb250ZXh0Jykuc2V0KGtleSwgY29udGV4dCk7XG5cdHJldHVybiBjb250ZXh0O1xufVxuXG4vKipcbiAqIEBwYXJhbSB7YW55fSBrZXlcbiAqIEByZXR1cm5zIHtib29sZWFufVxuICovXG5leHBvcnQgZnVuY3Rpb24gaGFzQ29udGV4dChrZXkpIHtcblx0cmV0dXJuIGdldF9vcl9pbml0X2NvbnRleHRfbWFwKCdoYXNDb250ZXh0JykuaGFzKGtleSk7XG59XG5cbi8qKiBAcmV0dXJucyB7TWFwPGFueSwgYW55Pn0gKi9cbmV4cG9ydCBmdW5jdGlvbiBnZXRBbGxDb250ZXh0cygpIHtcblx0cmV0dXJuIGdldF9vcl9pbml0X2NvbnRleHRfbWFwKCdnZXRBbGxDb250ZXh0cycpO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7c3RyaW5nfSBuYW1lXG4gKiBAcmV0dXJucyB7TWFwPHVua25vd24sIHVua25vd24+fVxuICovXG5mdW5jdGlvbiBnZXRfb3JfaW5pdF9jb250ZXh0X21hcChuYW1lKSB7XG5cdGlmIChjdXJyZW50X2NvbXBvbmVudCA9PT0gbnVsbCkge1xuXHRcdGUubGlmZWN5Y2xlX291dHNpZGVfY29tcG9uZW50KG5hbWUpO1xuXHR9XG5cblx0cmV0dXJuIChjdXJyZW50X2NvbXBvbmVudC5jID8/PSBuZXcgTWFwKGdldF9wYXJlbnRfY29udGV4dChjdXJyZW50X2NvbXBvbmVudCkgfHwgdW5kZWZpbmVkKSk7XG59XG5cbi8qKlxuICogQHBhcmFtIHtGdW5jdGlvbn0gW2ZuXVxuICovXG5leHBvcnQgZnVuY3Rpb24gcHVzaChmbikge1xuXHRjdXJyZW50X2NvbXBvbmVudCA9IHsgcDogY3VycmVudF9jb21wb25lbnQsIGM6IG51bGwsIGQ6IG51bGwgfTtcblx0aWYgKERFVikge1xuXHRcdC8vIGNvbXBvbmVudCBmdW5jdGlvblxuXHRcdGN1cnJlbnRfY29tcG9uZW50LmZ1bmN0aW9uID0gZm47XG5cdH1cbn1cblxuZXhwb3J0IGZ1bmN0aW9uIHBvcCgpIHtcblx0dmFyIGNvbXBvbmVudCA9IC8qKiBAdHlwZSB7Q29tcG9uZW50fSAqLyAoY3VycmVudF9jb21wb25lbnQpO1xuXG5cdHZhciBvbmRlc3Ryb3kgPSBjb21wb25lbnQuZDtcblxuXHRpZiAob25kZXN0cm95KSB7XG5cdFx0b25fZGVzdHJveS5wdXNoKC4uLm9uZGVzdHJveSk7XG5cdH1cblxuXHRjdXJyZW50X2NvbXBvbmVudCA9IGNvbXBvbmVudC5wO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7Q29tcG9uZW50fSBjb21wb25lbnRfY29udGV4dFxuICogQHJldHVybnMge01hcDx1bmtub3duLCB1bmtub3duPiB8IG51bGx9XG4gKi9cbmZ1bmN0aW9uIGdldF9wYXJlbnRfY29udGV4dChjb21wb25lbnRfY29udGV4dCkge1xuXHRsZXQgcGFyZW50ID0gY29tcG9uZW50X2NvbnRleHQucDtcblxuXHR3aGlsZSAocGFyZW50ICE9PSBudWxsKSB7XG5cdFx0Y29uc3QgY29udGV4dF9tYXAgPSBwYXJlbnQuYztcblx0XHRpZiAoY29udGV4dF9tYXAgIT09IG51bGwpIHtcblx0XHRcdHJldHVybiBjb250ZXh0X21hcDtcblx0XHR9XG5cdFx0cGFyZW50ID0gcGFyZW50LnA7XG5cdH1cblxuXHRyZXR1cm4gbnVsbDtcbn1cbiIsICJpbXBvcnQgeyBIWURSQVRJT05fRU5ELCBIWURSQVRJT05fU1RBUlQsIEhZRFJBVElPTl9TVEFSVF9FTFNFIH0gZnJvbSAnLi4vLi4vY29uc3RhbnRzLmpzJztcblxuZXhwb3J0IGNvbnN0IEJMT0NLX09QRU4gPSBgPCEtLSR7SFlEUkFUSU9OX1NUQVJUfS0tPmA7XG5leHBvcnQgY29uc3QgQkxPQ0tfT1BFTl9FTFNFID0gYDwhLS0ke0hZRFJBVElPTl9TVEFSVF9FTFNFfS0tPmA7XG5leHBvcnQgY29uc3QgQkxPQ0tfQ0xPU0UgPSBgPCEtLSR7SFlEUkFUSU9OX0VORH0tLT5gO1xuZXhwb3J0IGNvbnN0IEVNUFRZX0NPTU1FTlQgPSBgPCEtLS0tPmA7XG4iLCAiLyoqXG4gKiBNYXAgb2YgZWxlbWVudHMgdGhhdCBoYXZlIGNlcnRhaW4gZWxlbWVudHMgdGhhdCBhcmUgbm90IGFsbG93ZWQgaW5zaWRlIHRoZW0sIGluIHRoZSBzZW5zZSB0aGF0IHRoZXkgd2lsbCBhdXRvLWNsb3NlIHRoZSBwYXJlbnQvYW5jZXN0b3IgZWxlbWVudC5cbiAqIFRoZW9yZXRpY2FsbHkgb25lIGNvdWxkIHRha2UgYWR2YW50YWdlIG9mIGl0IGJ1dCBtb3N0IG9mIHRoZSB0aW1lIGl0IHdpbGwganVzdCByZXN1bHQgaW4gY29uZnVzaW5nIGJlaGF2aW9yIGFuZCBicmVhayB3aGVuIFNTUidkLlxuICogVGhlcmUgYXJlIG1vcmUgZWxlbWVudHMgdGhhdCBhcmUgaW52YWxpZCBpbnNpZGUgb3RoZXIgZWxlbWVudHMsIGJ1dCB0aGV5J3JlIG5vdCBhdXRvLWNsb3NlZCBhbmQgc28gZG9uJ3QgYnJlYWsgU1NSIGFuZCBhcmUgdGhlcmVmb3JlIG5vdCBsaXN0ZWQgaGVyZS5cbiAqIEB0eXBlIHtSZWNvcmQ8c3RyaW5nLCB7IGRpcmVjdDogc3RyaW5nW119IHwgeyBkZXNjZW5kYW50OiBzdHJpbmdbXTsgcmVzZXRfYnk/OiBzdHJpbmdbXSB9Pn1cbiAqL1xuY29uc3QgYXV0b2Nsb3NpbmdfY2hpbGRyZW4gPSB7XG5cdC8vIGJhc2VkIG9uIGh0dHA6Ly9kZXZlbG9wZXJzLndoYXR3Zy5vcmcvc3ludGF4Lmh0bWwjc3ludGF4LXRhZy1vbWlzc2lvblxuXHRsaTogeyBkaXJlY3Q6IFsnbGknXSB9LFxuXHQvLyBodHRwczovL2RldmVsb3Blci5tb3ppbGxhLm9yZy9lbi1VUy9kb2NzL1dlYi9IVE1ML0VsZW1lbnQvZHQjdGVjaG5pY2FsX3N1bW1hcnlcblx0ZHQ6IHsgZGVzY2VuZGFudDogWydkdCcsICdkZCddLCByZXNldF9ieTogWydkbCddIH0sXG5cdGRkOiB7IGRlc2NlbmRhbnQ6IFsnZHQnLCAnZGQnXSwgcmVzZXRfYnk6IFsnZGwnXSB9LFxuXHRwOiB7XG5cdFx0ZGVzY2VuZGFudDogW1xuXHRcdFx0J2FkZHJlc3MnLFxuXHRcdFx0J2FydGljbGUnLFxuXHRcdFx0J2FzaWRlJyxcblx0XHRcdCdibG9ja3F1b3RlJyxcblx0XHRcdCdkaXYnLFxuXHRcdFx0J2RsJyxcblx0XHRcdCdmaWVsZHNldCcsXG5cdFx0XHQnZm9vdGVyJyxcblx0XHRcdCdmb3JtJyxcblx0XHRcdCdoMScsXG5cdFx0XHQnaDInLFxuXHRcdFx0J2gzJyxcblx0XHRcdCdoNCcsXG5cdFx0XHQnaDUnLFxuXHRcdFx0J2g2Jyxcblx0XHRcdCdoZWFkZXInLFxuXHRcdFx0J2hncm91cCcsXG5cdFx0XHQnaHInLFxuXHRcdFx0J21haW4nLFxuXHRcdFx0J21lbnUnLFxuXHRcdFx0J25hdicsXG5cdFx0XHQnb2wnLFxuXHRcdFx0J3AnLFxuXHRcdFx0J3ByZScsXG5cdFx0XHQnc2VjdGlvbicsXG5cdFx0XHQndGFibGUnLFxuXHRcdFx0J3VsJ1xuXHRcdF1cblx0fSxcblx0cnQ6IHsgZGVzY2VuZGFudDogWydydCcsICdycCddIH0sXG5cdHJwOiB7IGRlc2NlbmRhbnQ6IFsncnQnLCAncnAnXSB9LFxuXHRvcHRncm91cDogeyBkZXNjZW5kYW50OiBbJ29wdGdyb3VwJ10gfSxcblx0b3B0aW9uOiB7IGRlc2NlbmRhbnQ6IFsnb3B0aW9uJywgJ29wdGdyb3VwJ10gfSxcblx0dGhlYWQ6IHsgZGlyZWN0OiBbJ3Rib2R5JywgJ3Rmb290J10gfSxcblx0dGJvZHk6IHsgZGlyZWN0OiBbJ3Rib2R5JywgJ3Rmb290J10gfSxcblx0dGZvb3Q6IHsgZGlyZWN0OiBbJ3Rib2R5J10gfSxcblx0dHI6IHsgZGlyZWN0OiBbJ3RyJywgJ3Rib2R5J10gfSxcblx0dGQ6IHsgZGlyZWN0OiBbJ3RkJywgJ3RoJywgJ3RyJ10gfSxcblx0dGg6IHsgZGlyZWN0OiBbJ3RkJywgJ3RoJywgJ3RyJ10gfVxufTtcblxuLyoqXG4gKiBSZXR1cm5zIHRydWUgaWYgdGhlIHRhZyBpcyBlaXRoZXIgdGhlIGxhc3QgaW4gdGhlIGxpc3Qgb2Ygc2libGluZ3MgYW5kIHdpbGwgYmUgYXV0b2Nsb3NlZCxcbiAqIG9yIG5vdCBhbGxvd2VkIGluc2lkZSB0aGUgcGFyZW50IHRhZyBzdWNoIHRoYXQgaXQgd2lsbCBhdXRvLWNsb3NlIGl0LiBUaGUgbGF0dGVyIHJlc3VsdHNcbiAqIGluIHRoZSBicm93c2VyIHJlcGFpcmluZyB0aGUgSFRNTCwgd2hpY2ggd2lsbCBsaWtlbHkgcmVzdWx0IGluIGFuIGVycm9yIGR1cmluZyBoeWRyYXRpb24uXG4gKiBAcGFyYW0ge3N0cmluZ30gY3VycmVudFxuICogQHBhcmFtIHtzdHJpbmd9IFtuZXh0XVxuICovXG5leHBvcnQgZnVuY3Rpb24gY2xvc2luZ190YWdfb21pdHRlZChjdXJyZW50LCBuZXh0KSB7XG5cdGNvbnN0IGRpc2FsbG93ZWQgPSBhdXRvY2xvc2luZ19jaGlsZHJlbltjdXJyZW50XTtcblx0aWYgKGRpc2FsbG93ZWQpIHtcblx0XHRpZiAoXG5cdFx0XHQhbmV4dCB8fFxuXHRcdFx0KCdkaXJlY3QnIGluIGRpc2FsbG93ZWQgPyBkaXNhbGxvd2VkLmRpcmVjdCA6IGRpc2FsbG93ZWQuZGVzY2VuZGFudCkuaW5jbHVkZXMobmV4dClcblx0XHQpIHtcblx0XHRcdHJldHVybiB0cnVlO1xuXHRcdH1cblx0fVxuXHRyZXR1cm4gZmFsc2U7XG59XG5cbi8qKlxuICogTWFwIG9mIGVsZW1lbnRzIHRoYXQgaGF2ZSBjZXJ0YWluIGVsZW1lbnRzIHRoYXQgYXJlIG5vdCBhbGxvd2VkIGluc2lkZSB0aGVtLCBpbiB0aGUgc2Vuc2UgdGhhdCB0aGUgYnJvd3NlciB3aWxsIHNvbWVob3cgcmVwYWlyIHRoZSBIVE1MLlxuICogVGhlcmUgYXJlIG1vcmUgZWxlbWVudHMgdGhhdCBhcmUgaW52YWxpZCBpbnNpZGUgb3RoZXIgZWxlbWVudHMsIGJ1dCB0aGV5J3JlIG5vdCByZXBhaXJlZCBhbmQgc28gZG9uJ3QgYnJlYWsgU1NSIGFuZCBhcmUgdGhlcmVmb3JlIG5vdCBsaXN0ZWQgaGVyZS5cbiAqIEB0eXBlIHtSZWNvcmQ8c3RyaW5nLCB7IGRpcmVjdDogc3RyaW5nW119IHwgeyBkZXNjZW5kYW50OiBzdHJpbmdbXTsgcmVzZXRfYnk/OiBzdHJpbmdbXTsgb25seT86IHN0cmluZ1tdIH0gfCB7IG9ubHk6IHN0cmluZ1tdIH0+fVxuICovXG5jb25zdCBkaXNhbGxvd2VkX2NoaWxkcmVuID0ge1xuXHQuLi5hdXRvY2xvc2luZ19jaGlsZHJlbixcblx0b3B0Z3JvdXA6IHsgb25seTogWydvcHRpb24nLCAnI3RleHQnXSB9LFxuXHQvLyBTdHJpY3RseSBzcGVha2luZywgc2VlaW5nIGFuIDxvcHRpb24+IGRvZXNuJ3QgbWVhbiB3ZSdyZSBpbiBhIDxzZWxlY3Q+LCBidXQgd2UgYXNzdW1lIGl0IGhlcmVcblx0b3B0aW9uOiB7IG9ubHk6IFsnI3RleHQnXSB9LFxuXHRmb3JtOiB7IGRlc2NlbmRhbnQ6IFsnZm9ybSddIH0sXG5cdGE6IHsgZGVzY2VuZGFudDogWydhJ10gfSxcblx0YnV0dG9uOiB7IGRlc2NlbmRhbnQ6IFsnYnV0dG9uJ10gfSxcblx0aDE6IHsgZGVzY2VuZGFudDogWydoMScsICdoMicsICdoMycsICdoNCcsICdoNScsICdoNiddIH0sXG5cdGgyOiB7IGRlc2NlbmRhbnQ6IFsnaDEnLCAnaDInLCAnaDMnLCAnaDQnLCAnaDUnLCAnaDYnXSB9LFxuXHRoMzogeyBkZXNjZW5kYW50OiBbJ2gxJywgJ2gyJywgJ2gzJywgJ2g0JywgJ2g1JywgJ2g2J10gfSxcblx0aDQ6IHsgZGVzY2VuZGFudDogWydoMScsICdoMicsICdoMycsICdoNCcsICdoNScsICdoNiddIH0sXG5cdGg1OiB7IGRlc2NlbmRhbnQ6IFsnaDEnLCAnaDInLCAnaDMnLCAnaDQnLCAnaDUnLCAnaDYnXSB9LFxuXHRoNjogeyBkZXNjZW5kYW50OiBbJ2gxJywgJ2gyJywgJ2gzJywgJ2g0JywgJ2g1JywgJ2g2J10gfSxcblx0Ly8gaHR0cHM6Ly9odG1sLnNwZWMud2hhdHdnLm9yZy9tdWx0aXBhZ2Uvc3ludGF4Lmh0bWwjcGFyc2luZy1tYWluLWluc2VsZWN0XG5cdHNlbGVjdDogeyBvbmx5OiBbJ29wdGlvbicsICdvcHRncm91cCcsICcjdGV4dCcsICdocicsICdzY3JpcHQnLCAndGVtcGxhdGUnXSB9LFxuXG5cdC8vIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL3N5bnRheC5odG1sI3BhcnNpbmctbWFpbi1pbnRkXG5cdC8vIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL3N5bnRheC5odG1sI3BhcnNpbmctbWFpbi1pbmNhcHRpb25cblx0Ly8gTm8gc3BlY2lhbCBiZWhhdmlvciBzaW5jZSB0aGVzZSBydWxlcyBmYWxsIGJhY2sgdG8gXCJpbiBib2R5XCIgbW9kZSBmb3Jcblx0Ly8gYWxsIGV4Y2VwdCBzcGVjaWFsIHRhYmxlIG5vZGVzIHdoaWNoIGNhdXNlIGJhZCBwYXJzaW5nIGJlaGF2aW9yIGFueXdheS5cblxuXHQvLyBodHRwczovL2h0bWwuc3BlYy53aGF0d2cub3JnL211bHRpcGFnZS9zeW50YXguaHRtbCNwYXJzaW5nLW1haW4taW50ZFxuXHR0cjogeyBvbmx5OiBbJ3RoJywgJ3RkJywgJ3N0eWxlJywgJ3NjcmlwdCcsICd0ZW1wbGF0ZSddIH0sXG5cdC8vIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL3N5bnRheC5odG1sI3BhcnNpbmctbWFpbi1pbnRib2R5XG5cdHRib2R5OiB7IG9ubHk6IFsndHInLCAnc3R5bGUnLCAnc2NyaXB0JywgJ3RlbXBsYXRlJ10gfSxcblx0dGhlYWQ6IHsgb25seTogWyd0cicsICdzdHlsZScsICdzY3JpcHQnLCAndGVtcGxhdGUnXSB9LFxuXHR0Zm9vdDogeyBvbmx5OiBbJ3RyJywgJ3N0eWxlJywgJ3NjcmlwdCcsICd0ZW1wbGF0ZSddIH0sXG5cdC8vIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL3N5bnRheC5odG1sI3BhcnNpbmctbWFpbi1pbmNvbGdyb3VwXG5cdGNvbGdyb3VwOiB7IG9ubHk6IFsnY29sJywgJ3RlbXBsYXRlJ10gfSxcblx0Ly8gaHR0cHM6Ly9odG1sLnNwZWMud2hhdHdnLm9yZy9tdWx0aXBhZ2Uvc3ludGF4Lmh0bWwjcGFyc2luZy1tYWluLWludGFibGVcblx0dGFibGU6IHtcblx0XHRvbmx5OiBbJ2NhcHRpb24nLCAnY29sZ3JvdXAnLCAndGJvZHknLCAndGhlYWQnLCAndGZvb3QnLCAnc3R5bGUnLCAnc2NyaXB0JywgJ3RlbXBsYXRlJ11cblx0fSxcblx0Ly8gaHR0cHM6Ly9odG1sLnNwZWMud2hhdHdnLm9yZy9tdWx0aXBhZ2Uvc3ludGF4Lmh0bWwjcGFyc2luZy1tYWluLWluaGVhZFxuXHRoZWFkOiB7XG5cdFx0b25seTogW1xuXHRcdFx0J2Jhc2UnLFxuXHRcdFx0J2Jhc2Vmb250Jyxcblx0XHRcdCdiZ3NvdW5kJyxcblx0XHRcdCdsaW5rJyxcblx0XHRcdCdtZXRhJyxcblx0XHRcdCd0aXRsZScsXG5cdFx0XHQnbm9zY3JpcHQnLFxuXHRcdFx0J25vZnJhbWVzJyxcblx0XHRcdCdzdHlsZScsXG5cdFx0XHQnc2NyaXB0Jyxcblx0XHRcdCd0ZW1wbGF0ZSdcblx0XHRdXG5cdH0sXG5cdC8vIGh0dHBzOi8vaHRtbC5zcGVjLndoYXR3Zy5vcmcvbXVsdGlwYWdlL3NlbWFudGljcy5odG1sI3RoZS1odG1sLWVsZW1lbnRcblx0aHRtbDogeyBvbmx5OiBbJ2hlYWQnLCAnYm9keScsICdmcmFtZXNldCddIH0sXG5cdGZyYW1lc2V0OiB7IG9ubHk6IFsnZnJhbWUnXSB9LFxuXHQnI2RvY3VtZW50JzogeyBvbmx5OiBbJ2h0bWwnXSB9XG59O1xuXG4vKipcbiAqIFJldHVybnMgYW4gZXJyb3IgbWVzc2FnZSBpZiB0aGUgdGFnIGlzIG5vdCBhbGxvd2VkIGluc2lkZSB0aGUgYW5jZXN0b3IgdGFnICh3aGljaCBpcyBncmFuZHBhcmVudCBhbmQgYWJvdmUpIHN1Y2ggdGhhdCBpdCB3aWxsIHJlc3VsdFxuICogaW4gdGhlIGJyb3dzZXIgcmVwYWlyaW5nIHRoZSBIVE1MLCB3aGljaCB3aWxsIGxpa2VseSByZXN1bHQgaW4gYW4gZXJyb3IgZHVyaW5nIGh5ZHJhdGlvbi5cbiAqIEBwYXJhbSB7c3RyaW5nfSBjaGlsZF90YWdcbiAqIEBwYXJhbSB7c3RyaW5nW119IGFuY2VzdG9ycyBBbGwgbm9kZXMgc3RhcnRpbmcgd2l0aCB0aGUgcGFyZW50LCB1cCB1bnRpbCB0aGUgYW5jZXN0b3IsIHdoaWNoIG1lYW5zIHR3byBlbnRyaWVzIG1pbmltdW1cbiAqIEBwYXJhbSB7c3RyaW5nfSBbY2hpbGRfbG9jXVxuICogQHBhcmFtIHtzdHJpbmd9IFthbmNlc3Rvcl9sb2NdXG4gKiBAcmV0dXJucyB7c3RyaW5nIHwgbnVsbH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGlzX3RhZ192YWxpZF93aXRoX2FuY2VzdG9yKGNoaWxkX3RhZywgYW5jZXN0b3JzLCBjaGlsZF9sb2MsIGFuY2VzdG9yX2xvYykge1xuXHRpZiAoY2hpbGRfdGFnLmluY2x1ZGVzKCctJykpIHJldHVybiBudWxsOyAvLyBjdXN0b20gZWxlbWVudHMgY2FuIGJlIGFueXRoaW5nXG5cblx0Y29uc3QgYW5jZXN0b3JfdGFnID0gYW5jZXN0b3JzW2FuY2VzdG9ycy5sZW5ndGggLSAxXTtcblx0Y29uc3QgZGlzYWxsb3dlZCA9IGRpc2FsbG93ZWRfY2hpbGRyZW5bYW5jZXN0b3JfdGFnXTtcblx0aWYgKCFkaXNhbGxvd2VkKSByZXR1cm4gbnVsbDtcblxuXHRpZiAoJ3Jlc2V0X2J5JyBpbiBkaXNhbGxvd2VkICYmIGRpc2FsbG93ZWQucmVzZXRfYnkpIHtcblx0XHRmb3IgKGxldCBpID0gYW5jZXN0b3JzLmxlbmd0aCAtIDI7IGkgPj0gMDsgaS0tKSB7XG5cdFx0XHRjb25zdCBhbmNlc3RvciA9IGFuY2VzdG9yc1tpXTtcblx0XHRcdGlmIChhbmNlc3Rvci5pbmNsdWRlcygnLScpKSByZXR1cm4gbnVsbDsgLy8gY3VzdG9tIGVsZW1lbnRzIGNhbiBiZSBhbnl0aGluZ1xuXG5cdFx0XHQvLyBBIHJlc2V0IG1lYW5zIHRoYXQgZm9yYmlkZGVuIGRlc2NlbmRhbnRzIGFyZSBhbGxvd2VkIGFnYWluXG5cdFx0XHRpZiAoZGlzYWxsb3dlZC5yZXNldF9ieS5pbmNsdWRlcyhhbmNlc3RvcnNbaV0pKSB7XG5cdFx0XHRcdHJldHVybiBudWxsO1xuXHRcdFx0fVxuXHRcdH1cblx0fVxuXG5cdGlmICgnZGVzY2VuZGFudCcgaW4gZGlzYWxsb3dlZCAmJiBkaXNhbGxvd2VkLmRlc2NlbmRhbnQuaW5jbHVkZXMoY2hpbGRfdGFnKSkge1xuXHRcdGNvbnN0IGNoaWxkID0gY2hpbGRfbG9jID8gYFxcYDwke2NoaWxkX3RhZ30+XFxgICgke2NoaWxkX2xvY30pYCA6IGBcXGA8JHtjaGlsZF90YWd9PlxcYGA7XG5cdFx0Y29uc3QgYW5jZXN0b3IgPSBhbmNlc3Rvcl9sb2Ncblx0XHRcdD8gYFxcYDwke2FuY2VzdG9yX3RhZ30+XFxgICgke2FuY2VzdG9yX2xvY30pYFxuXHRcdFx0OiBgXFxgPCR7YW5jZXN0b3JfdGFnfT5cXGBgO1xuXG5cdFx0cmV0dXJuIGAke2NoaWxkfSBjYW5ub3QgYmUgYSBkZXNjZW5kYW50IG9mICR7YW5jZXN0b3J9YDtcblx0fVxuXG5cdHJldHVybiBudWxsO1xufVxuXG4vKipcbiAqIFJldHVybnMgYW4gZXJyb3IgbWVzc2FnZSBpZiB0aGUgdGFnIGlzIG5vdCBhbGxvd2VkIGluc2lkZSB0aGUgcGFyZW50IHRhZyBzdWNoIHRoYXQgaXQgd2lsbCByZXN1bHRcbiAqIGluIHRoZSBicm93c2VyIHJlcGFpcmluZyB0aGUgSFRNTCwgd2hpY2ggd2lsbCBsaWtlbHkgcmVzdWx0IGluIGFuIGVycm9yIGR1cmluZyBoeWRyYXRpb24uXG4gKiBAcGFyYW0ge3N0cmluZ30gY2hpbGRfdGFnXG4gKiBAcGFyYW0ge3N0cmluZ30gcGFyZW50X3RhZ1xuICogQHBhcmFtIHtzdHJpbmd9IFtjaGlsZF9sb2NdXG4gKiBAcGFyYW0ge3N0cmluZ30gW3BhcmVudF9sb2NdXG4gKiBAcmV0dXJucyB7c3RyaW5nIHwgbnVsbH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGlzX3RhZ192YWxpZF93aXRoX3BhcmVudChjaGlsZF90YWcsIHBhcmVudF90YWcsIGNoaWxkX2xvYywgcGFyZW50X2xvYykge1xuXHRpZiAoY2hpbGRfdGFnLmluY2x1ZGVzKCctJykgfHwgcGFyZW50X3RhZz8uaW5jbHVkZXMoJy0nKSkgcmV0dXJuIG51bGw7IC8vIGN1c3RvbSBlbGVtZW50cyBjYW4gYmUgYW55dGhpbmdcblxuXHRpZiAocGFyZW50X3RhZyA9PT0gJ3RlbXBsYXRlJykgcmV0dXJuIG51bGw7IC8vIG5vIGVycm9ycyBvciB3YXJuaW5nIHNob3VsZCBiZSB0aHJvd24gaW4gaW1tZWRpYXRlIGNoaWxkcmVuIG9mIHRlbXBsYXRlIHRhZ3NcblxuXHRjb25zdCBkaXNhbGxvd2VkID0gZGlzYWxsb3dlZF9jaGlsZHJlbltwYXJlbnRfdGFnXTtcblxuXHRjb25zdCBjaGlsZCA9IGNoaWxkX2xvYyA/IGBcXGA8JHtjaGlsZF90YWd9PlxcYCAoJHtjaGlsZF9sb2N9KWAgOiBgXFxgPCR7Y2hpbGRfdGFnfT5cXGBgO1xuXHRjb25zdCBwYXJlbnQgPSBwYXJlbnRfbG9jID8gYFxcYDwke3BhcmVudF90YWd9PlxcYCAoJHtwYXJlbnRfbG9jfSlgIDogYFxcYDwke3BhcmVudF90YWd9PlxcYGA7XG5cblx0aWYgKGRpc2FsbG93ZWQpIHtcblx0XHRpZiAoJ2RpcmVjdCcgaW4gZGlzYWxsb3dlZCAmJiBkaXNhbGxvd2VkLmRpcmVjdC5pbmNsdWRlcyhjaGlsZF90YWcpKSB7XG5cdFx0XHRyZXR1cm4gYCR7Y2hpbGR9IGNhbm5vdCBiZSBhIGRpcmVjdCBjaGlsZCBvZiAke3BhcmVudH1gO1xuXHRcdH1cblxuXHRcdGlmICgnZGVzY2VuZGFudCcgaW4gZGlzYWxsb3dlZCAmJiBkaXNhbGxvd2VkLmRlc2NlbmRhbnQuaW5jbHVkZXMoY2hpbGRfdGFnKSkge1xuXHRcdFx0cmV0dXJuIGAke2NoaWxkfSBjYW5ub3QgYmUgYSBjaGlsZCBvZiAke3BhcmVudH1gO1xuXHRcdH1cblxuXHRcdGlmICgnb25seScgaW4gZGlzYWxsb3dlZCAmJiBkaXNhbGxvd2VkLm9ubHkpIHtcblx0XHRcdGlmIChkaXNhbGxvd2VkLm9ubHkuaW5jbHVkZXMoY2hpbGRfdGFnKSkge1xuXHRcdFx0XHRyZXR1cm4gbnVsbDtcblx0XHRcdH0gZWxzZSB7XG5cdFx0XHRcdHJldHVybiBgJHtjaGlsZH0gY2Fubm90IGJlIGEgY2hpbGQgb2YgJHtwYXJlbnR9LiBcXGA8JHtwYXJlbnRfdGFnfT5cXGAgb25seSBhbGxvd3MgdGhlc2UgY2hpbGRyZW46ICR7ZGlzYWxsb3dlZC5vbmx5Lm1hcCgoZCkgPT4gYFxcYDwke2R9PlxcYGApLmpvaW4oJywgJyl9YDtcblx0XHRcdH1cblx0XHR9XG5cdH1cblxuXHQvLyBUaGVzZSB0YWdzIGFyZSBvbmx5IHZhbGlkIHdpdGggYSBmZXcgcGFyZW50cyB0aGF0IGhhdmUgc3BlY2lhbCBjaGlsZFxuXHQvLyBwYXJzaW5nIHJ1bGVzIC0gaWYgd2UncmUgZG93biBoZXJlLCB0aGVuIG5vbmUgb2YgdGhvc2UgbWF0Y2hlZCBhbmRcblx0Ly8gc28gd2UgYWxsb3cgaXQgb25seSBpZiB3ZSBkb24ndCBrbm93IHdoYXQgdGhlIHBhcmVudCBpcywgYXMgYWxsIG90aGVyXG5cdC8vIGNhc2VzIGFyZSBpbnZhbGlkIChhbmQgd2Ugb25seSBnZXQgaW50byB0aGlzIGZ1bmN0aW9uIGlmIHdlIGtub3cgdGhlIHBhcmVudCkuXG5cdHN3aXRjaCAoY2hpbGRfdGFnKSB7XG5cdFx0Y2FzZSAnYm9keSc6XG5cdFx0Y2FzZSAnY2FwdGlvbic6XG5cdFx0Y2FzZSAnY29sJzpcblx0XHRjYXNlICdjb2xncm91cCc6XG5cdFx0Y2FzZSAnZnJhbWVzZXQnOlxuXHRcdGNhc2UgJ2ZyYW1lJzpcblx0XHRjYXNlICdoZWFkJzpcblx0XHRjYXNlICdodG1sJzpcblx0XHRcdHJldHVybiBgJHtjaGlsZH0gY2Fubm90IGJlIGEgY2hpbGQgb2YgJHtwYXJlbnR9YDtcblx0XHRjYXNlICd0aGVhZCc6XG5cdFx0Y2FzZSAndGJvZHknOlxuXHRcdGNhc2UgJ3Rmb290Jzpcblx0XHRcdHJldHVybiBgJHtjaGlsZH0gbXVzdCBiZSB0aGUgY2hpbGQgb2YgYSBcXGA8dGFibGU+XFxgLCBub3QgYSAke3BhcmVudH1gO1xuXHRcdGNhc2UgJ3RkJzpcblx0XHRjYXNlICd0aCc6XG5cdFx0XHRyZXR1cm4gYCR7Y2hpbGR9IG11c3QgYmUgdGhlIGNoaWxkIG9mIGEgXFxgPHRyPlxcYCwgbm90IGEgJHtwYXJlbnR9YDtcblx0XHRjYXNlICd0cic6XG5cdFx0XHRyZXR1cm4gYFxcYDx0cj5cXGAgbXVzdCBiZSB0aGUgY2hpbGQgb2YgYSBcXGA8dGhlYWQ+XFxgLCBcXGA8dGJvZHk+XFxgLCBvciBcXGA8dGZvb3Q+XFxgLCBub3QgYSAke3BhcmVudH1gO1xuXHR9XG5cblx0cmV0dXJuIG51bGw7XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBDb21wb25lbnQsIFBheWxvYWQgfSBmcm9tICcjc2VydmVyJyAqL1xuaW1wb3J0IHsgRklMRU5BTUUgfSBmcm9tICcuLi8uLi9jb25zdGFudHMuanMnO1xuaW1wb3J0IHtcblx0aXNfdGFnX3ZhbGlkX3dpdGhfYW5jZXN0b3IsXG5cdGlzX3RhZ192YWxpZF93aXRoX3BhcmVudFxufSBmcm9tICcuLi8uLi9odG1sLXRyZWUtdmFsaWRhdGlvbi5qcyc7XG5pbXBvcnQgeyBjdXJyZW50X2NvbXBvbmVudCB9IGZyb20gJy4vY29udGV4dC5qcyc7XG5cbi8qKlxuICogQHR5cGVkZWYge3tcbiAqIFx0dGFnOiBzdHJpbmc7XG4gKiBcdHBhcmVudDogbnVsbCB8IEVsZW1lbnQ7XG4gKiAgZmlsZW5hbWU6IG51bGwgfCBzdHJpbmc7XG4gKiAgbGluZTogbnVtYmVyO1xuICogIGNvbHVtbjogbnVtYmVyO1xuICogfX0gRWxlbWVudFxuICovXG5cbi8qKlxuICogQHR5cGUge0VsZW1lbnQgfCBudWxsfVxuICovXG5sZXQgcGFyZW50ID0gbnVsbDtcblxuLyoqIEB0eXBlIHtTZXQ8c3RyaW5nPn0gKi9cbmxldCBzZWVuO1xuXG4vKipcbiAqIEBwYXJhbSB7RWxlbWVudH0gZWxlbWVudFxuICovXG5mdW5jdGlvbiBzdHJpbmdpZnkoZWxlbWVudCkge1xuXHRpZiAoZWxlbWVudC5maWxlbmFtZSA9PT0gbnVsbCkgcmV0dXJuIGBcXGA8JHtlbGVtZW50LnRhZ30+XFxgYDtcblx0cmV0dXJuIGBcXGA8JHtlbGVtZW50LnRhZ30+XFxgICgke2VsZW1lbnQuZmlsZW5hbWV9OiR7ZWxlbWVudC5saW5lfToke2VsZW1lbnQuY29sdW1ufSlgO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7UGF5bG9hZH0gcGF5bG9hZFxuICogQHBhcmFtIHtzdHJpbmd9IG1lc3NhZ2VcbiAqL1xuZnVuY3Rpb24gcHJpbnRfZXJyb3IocGF5bG9hZCwgbWVzc2FnZSkge1xuXHRtZXNzYWdlID1cblx0XHRgbm9kZV9pbnZhbGlkX3BsYWNlbWVudF9zc3I6ICR7bWVzc2FnZX1cXG5cXG5gICtcblx0XHQnVGhpcyBjYW4gY2F1c2UgY29udGVudCB0byBzaGlmdCBhcm91bmQgYXMgdGhlIGJyb3dzZXIgcmVwYWlycyB0aGUgSFRNTCwgYW5kIHdpbGwgbGlrZWx5IHJlc3VsdCBpbiBhIGBoeWRyYXRpb25fbWlzbWF0Y2hgIHdhcm5pbmcuJztcblxuXHRpZiAoKHNlZW4gPz89IG5ldyBTZXQoKSkuaGFzKG1lc3NhZ2UpKSByZXR1cm47XG5cdHNlZW4uYWRkKG1lc3NhZ2UpO1xuXG5cdC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25zb2xlXG5cdGNvbnNvbGUuZXJyb3IobWVzc2FnZSk7XG5cdHBheWxvYWQuaGVhZC5vdXQgKz0gYDxzY3JpcHQ+Y29uc29sZS5lcnJvcigke0pTT04uc3RyaW5naWZ5KG1lc3NhZ2UpfSk8L3NjcmlwdD5gO1xufVxuXG5leHBvcnQgZnVuY3Rpb24gcmVzZXRfZWxlbWVudHMoKSB7XG5cdGxldCBvbGRfcGFyZW50ID0gcGFyZW50O1xuXHRwYXJlbnQgPSBudWxsO1xuXHRyZXR1cm4gKCkgPT4ge1xuXHRcdHBhcmVudCA9IG9sZF9wYXJlbnQ7XG5cdH07XG59XG5cbi8qKlxuICogQHBhcmFtIHtQYXlsb2FkfSBwYXlsb2FkXG4gKiBAcGFyYW0ge3N0cmluZ30gdGFnXG4gKiBAcGFyYW0ge251bWJlcn0gbGluZVxuICogQHBhcmFtIHtudW1iZXJ9IGNvbHVtblxuICovXG5leHBvcnQgZnVuY3Rpb24gcHVzaF9lbGVtZW50KHBheWxvYWQsIHRhZywgbGluZSwgY29sdW1uKSB7XG5cdHZhciBmaWxlbmFtZSA9IC8qKiBAdHlwZSB7Q29tcG9uZW50fSAqLyAoY3VycmVudF9jb21wb25lbnQpLmZ1bmN0aW9uW0ZJTEVOQU1FXTtcblx0dmFyIGNoaWxkID0geyB0YWcsIHBhcmVudCwgZmlsZW5hbWUsIGxpbmUsIGNvbHVtbiB9O1xuXG5cdGlmIChwYXJlbnQgIT09IG51bGwpIHtcblx0XHR2YXIgYW5jZXN0b3IgPSBwYXJlbnQucGFyZW50O1xuXHRcdHZhciBhbmNlc3RvcnMgPSBbcGFyZW50LnRhZ107XG5cblx0XHRjb25zdCBjaGlsZF9sb2MgPSBmaWxlbmFtZSA/IGAke2ZpbGVuYW1lfToke2xpbmV9OiR7Y29sdW1ufWAgOiB1bmRlZmluZWQ7XG5cdFx0Y29uc3QgcGFyZW50X2xvYyA9IHBhcmVudC5maWxlbmFtZVxuXHRcdFx0PyBgJHtwYXJlbnQuZmlsZW5hbWV9OiR7cGFyZW50LmxpbmV9OiR7cGFyZW50LmNvbHVtbn1gXG5cdFx0XHQ6IHVuZGVmaW5lZDtcblxuXHRcdGNvbnN0IG1lc3NhZ2UgPSBpc190YWdfdmFsaWRfd2l0aF9wYXJlbnQodGFnLCBwYXJlbnQudGFnLCBjaGlsZF9sb2MsIHBhcmVudF9sb2MpO1xuXHRcdGlmIChtZXNzYWdlKSBwcmludF9lcnJvcihwYXlsb2FkLCBtZXNzYWdlKTtcblxuXHRcdHdoaWxlIChhbmNlc3RvciAhPSBudWxsKSB7XG5cdFx0XHRhbmNlc3RvcnMucHVzaChhbmNlc3Rvci50YWcpO1xuXHRcdFx0Y29uc3QgYW5jZXN0b3JfbG9jID0gYW5jZXN0b3IuZmlsZW5hbWVcblx0XHRcdFx0PyBgJHthbmNlc3Rvci5maWxlbmFtZX06JHthbmNlc3Rvci5saW5lfToke2FuY2VzdG9yLmNvbHVtbn1gXG5cdFx0XHRcdDogdW5kZWZpbmVkO1xuXG5cdFx0XHRjb25zdCBtZXNzYWdlID0gaXNfdGFnX3ZhbGlkX3dpdGhfYW5jZXN0b3IodGFnLCBhbmNlc3RvcnMsIGNoaWxkX2xvYywgYW5jZXN0b3JfbG9jKTtcblx0XHRcdGlmIChtZXNzYWdlKSBwcmludF9lcnJvcihwYXlsb2FkLCBtZXNzYWdlKTtcblxuXHRcdFx0YW5jZXN0b3IgPSBhbmNlc3Rvci5wYXJlbnQ7XG5cdFx0fVxuXHR9XG5cblx0cGFyZW50ID0gY2hpbGQ7XG59XG5cbmV4cG9ydCBmdW5jdGlvbiBwb3BfZWxlbWVudCgpIHtcblx0cGFyZW50ID0gLyoqIEB0eXBlIHtFbGVtZW50fSAqLyAocGFyZW50KS5wYXJlbnQ7XG59XG4iLCAiLyoqIEBpbXBvcnQgeyBDb21wb25lbnRUeXBlLCBTdmVsdGVDb21wb25lbnQgfSBmcm9tICdzdmVsdGUnICovXG4vKiogQGltcG9ydCB7IENvbXBvbmVudCwgUGF5bG9hZCwgUmVuZGVyT3V0cHV0IH0gZnJvbSAnI3NlcnZlcicgKi9cbi8qKiBAaW1wb3J0IHsgU3RvcmUgfSBmcm9tICcjc2hhcmVkJyAqL1xuZXhwb3J0IHsgRklMRU5BTUUsIEhNUiB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy5qcyc7XG5pbXBvcnQgeyBhdHRyLCBjbHN4IH0gZnJvbSAnLi4vc2hhcmVkL2F0dHJpYnV0ZXMuanMnO1xuaW1wb3J0IHsgaXNfcHJvbWlzZSwgbm9vcCB9IGZyb20gJy4uL3NoYXJlZC91dGlscy5qcyc7XG5pbXBvcnQgeyBzdWJzY3JpYmVfdG9fc3RvcmUgfSBmcm9tICcuLi8uLi9zdG9yZS91dGlscy5qcyc7XG5pbXBvcnQge1xuXHRVTklOSVRJQUxJWkVELFxuXHRFTEVNRU5UX1BSRVNFUlZFX0FUVFJJQlVURV9DQVNFLFxuXHRFTEVNRU5UX0lTX05BTUVTUEFDRURcbn0gZnJvbSAnLi4vLi4vY29uc3RhbnRzLmpzJztcblxuaW1wb3J0IHsgZXNjYXBlX2h0bWwgfSBmcm9tICcuLi8uLi9lc2NhcGluZy5qcyc7XG5pbXBvcnQgeyBERVYgfSBmcm9tICdlc20tZW52JztcbmltcG9ydCB7IGN1cnJlbnRfY29tcG9uZW50LCBwb3AsIHB1c2ggfSBmcm9tICcuL2NvbnRleHQuanMnO1xuaW1wb3J0IHsgRU1QVFlfQ09NTUVOVCwgQkxPQ0tfQ0xPU0UsIEJMT0NLX09QRU4gfSBmcm9tICcuL2h5ZHJhdGlvbi5qcyc7XG5pbXBvcnQgeyB2YWxpZGF0ZV9zdG9yZSB9IGZyb20gJy4uL3NoYXJlZC92YWxpZGF0ZS5qcyc7XG5pbXBvcnQgeyBpc19ib29sZWFuX2F0dHJpYnV0ZSwgaXNfcmF3X3RleHRfZWxlbWVudCwgaXNfdm9pZCB9IGZyb20gJy4uLy4uL3V0aWxzLmpzJztcbmltcG9ydCB7IHJlc2V0X2VsZW1lbnRzIH0gZnJvbSAnLi9kZXYuanMnO1xuXG4vLyBodHRwczovL2h0bWwuc3BlYy53aGF0d2cub3JnL211bHRpcGFnZS9zeW50YXguaHRtbCNhdHRyaWJ1dGVzLTJcbi8vIGh0dHBzOi8vaW5mcmEuc3BlYy53aGF0d2cub3JnLyNub25jaGFyYWN0ZXJcbmNvbnN0IElOVkFMSURfQVRUUl9OQU1FX0NIQVJfUkVHRVggPVxuXHQvW1xccydcIj4vPVxcdXtGREQwfS1cXHV7RkRFRn1cXHV7RkZGRX1cXHV7RkZGRn1cXHV7MUZGRkV9XFx1ezFGRkZGfVxcdXsyRkZGRX1cXHV7MkZGRkZ9XFx1ezNGRkZFfVxcdXszRkZGRn1cXHV7NEZGRkV9XFx1ezRGRkZGfVxcdXs1RkZGRX1cXHV7NUZGRkZ9XFx1ezZGRkZFfVxcdXs2RkZGRn1cXHV7N0ZGRkV9XFx1ezdGRkZGfVxcdXs4RkZGRX1cXHV7OEZGRkZ9XFx1ezlGRkZFfVxcdXs5RkZGRn1cXHV7QUZGRkV9XFx1e0FGRkZGfVxcdXtCRkZGRX1cXHV7QkZGRkZ9XFx1e0NGRkZFfVxcdXtDRkZGRn1cXHV7REZGRkV9XFx1e0RGRkZGfVxcdXtFRkZGRX1cXHV7RUZGRkZ9XFx1e0ZGRkZFfVxcdXtGRkZGRn1cXHV7MTBGRkZFfVxcdXsxMEZGRkZ9XS91O1xuXG4vKipcbiAqIEBwYXJhbSB7UGF5bG9hZH0gdG9fY29weVxuICogQHJldHVybnMge1BheWxvYWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjb3B5X3BheWxvYWQoeyBvdXQsIGNzcywgaGVhZCwgdWlkIH0pIHtcblx0cmV0dXJuIHtcblx0XHRvdXQsXG5cdFx0Y3NzOiBuZXcgU2V0KGNzcyksXG5cdFx0aGVhZDoge1xuXHRcdFx0dGl0bGU6IGhlYWQudGl0bGUsXG5cdFx0XHRvdXQ6IGhlYWQub3V0LFxuXHRcdFx0Y3NzOiBuZXcgU2V0KGhlYWQuY3NzKSxcblx0XHRcdHVpZDogaGVhZC51aWRcblx0XHR9LFxuXHRcdHVpZFxuXHR9O1xufVxuXG4vKipcbiAqIEFzc2lnbnMgc2Vjb25kIHBheWxvYWQgdG8gZmlyc3RcbiAqIEBwYXJhbSB7UGF5bG9hZH0gcDFcbiAqIEBwYXJhbSB7UGF5bG9hZH0gcDJcbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gYXNzaWduX3BheWxvYWQocDEsIHAyKSB7XG5cdHAxLm91dCA9IHAyLm91dDtcblx0cDEuaGVhZCA9IHAyLmhlYWQ7XG5cdHAxLnVpZCA9IHAyLnVpZDtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge1BheWxvYWR9IHBheWxvYWRcbiAqIEBwYXJhbSB7c3RyaW5nfSB0YWdcbiAqIEBwYXJhbSB7KCkgPT4gdm9pZH0gYXR0cmlidXRlc19mblxuICogQHBhcmFtIHsoKSA9PiB2b2lkfSBjaGlsZHJlbl9mblxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBlbGVtZW50KHBheWxvYWQsIHRhZywgYXR0cmlidXRlc19mbiA9IG5vb3AsIGNoaWxkcmVuX2ZuID0gbm9vcCkge1xuXHRwYXlsb2FkLm91dCArPSAnPCEtLS0tPic7XG5cblx0aWYgKHRhZykge1xuXHRcdHBheWxvYWQub3V0ICs9IGA8JHt0YWd9YDtcblx0XHRhdHRyaWJ1dGVzX2ZuKCk7XG5cdFx0cGF5bG9hZC5vdXQgKz0gYD5gO1xuXG5cdFx0aWYgKCFpc192b2lkKHRhZykpIHtcblx0XHRcdGNoaWxkcmVuX2ZuKCk7XG5cdFx0XHRpZiAoIWlzX3Jhd190ZXh0X2VsZW1lbnQodGFnKSkge1xuXHRcdFx0XHRwYXlsb2FkLm91dCArPSBFTVBUWV9DT01NRU5UO1xuXHRcdFx0fVxuXHRcdFx0cGF5bG9hZC5vdXQgKz0gYDwvJHt0YWd9PmA7XG5cdFx0fVxuXHR9XG5cblx0cGF5bG9hZC5vdXQgKz0gJzwhLS0tLT4nO1xufVxuXG4vKipcbiAqIEFycmF5IG9mIGBvbkRlc3Ryb3lgIGNhbGxiYWNrcyB0aGF0IHNob3VsZCBiZSBjYWxsZWQgYXQgdGhlIGVuZCBvZiB0aGUgc2VydmVyIHJlbmRlciBmdW5jdGlvblxuICogQHR5cGUge0Z1bmN0aW9uW119XG4gKi9cbmV4cG9ydCBsZXQgb25fZGVzdHJveSA9IFtdO1xuXG5mdW5jdGlvbiBwcm9wc19pZF9nZW5lcmF0b3IoKSB7XG5cdGxldCB1aWQgPSAxO1xuXHRyZXR1cm4gKCkgPT4gJ3MnICsgdWlkKys7XG59XG5cbi8qKlxuICogT25seSBhdmFpbGFibGUgb24gdGhlIHNlcnZlciBhbmQgd2hlbiBjb21waWxpbmcgd2l0aCB0aGUgYHNlcnZlcmAgb3B0aW9uLlxuICogVGFrZXMgYSBjb21wb25lbnQgYW5kIHJldHVybnMgYW4gb2JqZWN0IHdpdGggYGJvZHlgIGFuZCBgaGVhZGAgcHJvcGVydGllcyBvbiBpdCwgd2hpY2ggeW91IGNhbiB1c2UgdG8gcG9wdWxhdGUgdGhlIEhUTUwgd2hlbiBzZXJ2ZXItcmVuZGVyaW5nIHlvdXIgYXBwLlxuICogQHRlbXBsYXRlIHtSZWNvcmQ8c3RyaW5nLCBhbnk+fSBQcm9wc1xuICogQHBhcmFtIHtpbXBvcnQoJ3N2ZWx0ZScpLkNvbXBvbmVudDxQcm9wcz4gfCBDb21wb25lbnRUeXBlPFN2ZWx0ZUNvbXBvbmVudDxQcm9wcz4+fSBjb21wb25lbnRcbiAqIEBwYXJhbSB7eyBwcm9wcz86IE9taXQ8UHJvcHMsICckJHNsb3RzJyB8ICckJGV2ZW50cyc+OyBjb250ZXh0PzogTWFwPGFueSwgYW55PiwgdWlkPzogKCkgPT4gc3RyaW5nIH19IFtvcHRpb25zXVxuICogQHJldHVybnMge1JlbmRlck91dHB1dH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHJlbmRlcihjb21wb25lbnQsIG9wdGlvbnMgPSB7fSkge1xuXHRjb25zdCB1aWQgPSBvcHRpb25zLnVpZCA/PyBwcm9wc19pZF9nZW5lcmF0b3IoKTtcblx0LyoqIEB0eXBlIHtQYXlsb2FkfSAqL1xuXHRjb25zdCBwYXlsb2FkID0ge1xuXHRcdG91dDogJycsXG5cdFx0Y3NzOiBuZXcgU2V0KCksXG5cdFx0aGVhZDogeyB0aXRsZTogJycsIG91dDogJycsIGNzczogbmV3IFNldCgpLCB1aWQgfSxcblx0XHR1aWRcblx0fTtcblxuXHRjb25zdCBwcmV2X29uX2Rlc3Ryb3kgPSBvbl9kZXN0cm95O1xuXHRvbl9kZXN0cm95ID0gW107XG5cdHBheWxvYWQub3V0ICs9IEJMT0NLX09QRU47XG5cblx0bGV0IHJlc2V0X3Jlc2V0X2VsZW1lbnQ7XG5cblx0aWYgKERFVikge1xuXHRcdC8vIHByZXZlbnQgcGFyZW50L2NoaWxkIGVsZW1lbnQgc3RhdGUgYmVpbmcgY29ycnVwdGVkIGJ5IGEgYmFkIHJlbmRlclxuXHRcdHJlc2V0X3Jlc2V0X2VsZW1lbnQgPSByZXNldF9lbGVtZW50cygpO1xuXHR9XG5cblx0aWYgKG9wdGlvbnMuY29udGV4dCkge1xuXHRcdHB1c2goKTtcblx0XHQvKiogQHR5cGUge0NvbXBvbmVudH0gKi8gKGN1cnJlbnRfY29tcG9uZW50KS5jID0gb3B0aW9ucy5jb250ZXh0O1xuXHR9XG5cblx0Ly8gQHRzLWV4cGVjdC1lcnJvclxuXHRjb21wb25lbnQocGF5bG9hZCwgb3B0aW9ucy5wcm9wcyA/PyB7fSwge30sIHt9KTtcblxuXHRpZiAob3B0aW9ucy5jb250ZXh0KSB7XG5cdFx0cG9wKCk7XG5cdH1cblxuXHRpZiAocmVzZXRfcmVzZXRfZWxlbWVudCkge1xuXHRcdHJlc2V0X3Jlc2V0X2VsZW1lbnQoKTtcblx0fVxuXG5cdHBheWxvYWQub3V0ICs9IEJMT0NLX0NMT1NFO1xuXHRmb3IgKGNvbnN0IGNsZWFudXAgb2Ygb25fZGVzdHJveSkgY2xlYW51cCgpO1xuXHRvbl9kZXN0cm95ID0gcHJldl9vbl9kZXN0cm95O1xuXG5cdGxldCBoZWFkID0gcGF5bG9hZC5oZWFkLm91dCArIHBheWxvYWQuaGVhZC50aXRsZTtcblxuXHRmb3IgKGNvbnN0IHsgaGFzaCwgY29kZSB9IG9mIHBheWxvYWQuY3NzKSB7XG5cdFx0aGVhZCArPSBgPHN0eWxlIGlkPVwiJHtoYXNofVwiPiR7Y29kZX08L3N0eWxlPmA7XG5cdH1cblxuXHRyZXR1cm4ge1xuXHRcdGhlYWQsXG5cdFx0aHRtbDogcGF5bG9hZC5vdXQsXG5cdFx0Ym9keTogcGF5bG9hZC5vdXRcblx0fTtcbn1cblxuLyoqXG4gKiBAcGFyYW0ge1BheWxvYWR9IHBheWxvYWRcbiAqIEBwYXJhbSB7KGhlYWRfcGF5bG9hZDogUGF5bG9hZFsnaGVhZCddKSA9PiB2b2lkfSBmblxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBoZWFkKHBheWxvYWQsIGZuKSB7XG5cdGNvbnN0IGhlYWRfcGF5bG9hZCA9IHBheWxvYWQuaGVhZDtcblx0aGVhZF9wYXlsb2FkLm91dCArPSBCTE9DS19PUEVOO1xuXHRmbihoZWFkX3BheWxvYWQpO1xuXHRoZWFkX3BheWxvYWQub3V0ICs9IEJMT0NLX0NMT1NFO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7UGF5bG9hZH0gcGF5bG9hZFxuICogQHBhcmFtIHtib29sZWFufSBpc19odG1sXG4gKiBAcGFyYW0ge1JlY29yZDxzdHJpbmcsIHN0cmluZz59IHByb3BzXG4gKiBAcGFyYW0geygpID0+IHZvaWR9IGNvbXBvbmVudFxuICogQHBhcmFtIHtib29sZWFufSBkeW5hbWljXG4gKiBAcmV0dXJucyB7dm9pZH1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGNzc19wcm9wcyhwYXlsb2FkLCBpc19odG1sLCBwcm9wcywgY29tcG9uZW50LCBkeW5hbWljID0gZmFsc2UpIHtcblx0Y29uc3Qgc3R5bGVzID0gc3R5bGVfb2JqZWN0X3RvX3N0cmluZyhwcm9wcyk7XG5cblx0aWYgKGlzX2h0bWwpIHtcblx0XHRwYXlsb2FkLm91dCArPSBgPHN2ZWx0ZS1jc3Mtd3JhcHBlciBzdHlsZT1cImRpc3BsYXk6IGNvbnRlbnRzOyAke3N0eWxlc31cIj5gO1xuXHR9IGVsc2Uge1xuXHRcdHBheWxvYWQub3V0ICs9IGA8ZyBzdHlsZT1cIiR7c3R5bGVzfVwiPmA7XG5cdH1cblxuXHRpZiAoZHluYW1pYykge1xuXHRcdHBheWxvYWQub3V0ICs9ICc8IS0tLS0+Jztcblx0fVxuXG5cdGNvbXBvbmVudCgpO1xuXG5cdGlmIChpc19odG1sKSB7XG5cdFx0cGF5bG9hZC5vdXQgKz0gYDwhLS0tLT48L3N2ZWx0ZS1jc3Mtd3JhcHBlcj5gO1xuXHR9IGVsc2Uge1xuXHRcdHBheWxvYWQub3V0ICs9IGA8IS0tLS0+PC9nPmA7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge1JlY29yZDxzdHJpbmcsIHVua25vd24+fSBhdHRyc1xuICogQHBhcmFtIHtSZWNvcmQ8c3RyaW5nLCBzdHJpbmc+fSBbY2xhc3Nlc11cbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgc3RyaW5nPn0gW3N0eWxlc11cbiAqIEBwYXJhbSB7bnVtYmVyfSBbZmxhZ3NdXG4gKiBAcmV0dXJucyB7c3RyaW5nfVxuICovXG5leHBvcnQgZnVuY3Rpb24gc3ByZWFkX2F0dHJpYnV0ZXMoYXR0cnMsIGNsYXNzZXMsIHN0eWxlcywgZmxhZ3MgPSAwKSB7XG5cdGlmIChzdHlsZXMpIHtcblx0XHRhdHRycy5zdHlsZSA9IGF0dHJzLnN0eWxlXG5cdFx0XHQ/IHN0eWxlX29iamVjdF90b19zdHJpbmcobWVyZ2Vfc3R5bGVzKC8qKiBAdHlwZSB7c3RyaW5nfSAqLyAoYXR0cnMuc3R5bGUpLCBzdHlsZXMpKVxuXHRcdFx0OiBzdHlsZV9vYmplY3RfdG9fc3RyaW5nKHN0eWxlcyk7XG5cdH1cblxuXHRpZiAoYXR0cnMuY2xhc3MpIHtcblx0XHRhdHRycy5jbGFzcyA9IGNsc3goYXR0cnMuY2xhc3MpO1xuXHR9XG5cblx0aWYgKGNsYXNzZXMpIHtcblx0XHRjb25zdCBjbGFzc2xpc3QgPSBhdHRycy5jbGFzcyA/IFthdHRycy5jbGFzc10gOiBbXTtcblxuXHRcdGZvciAoY29uc3Qga2V5IGluIGNsYXNzZXMpIHtcblx0XHRcdGlmIChjbGFzc2VzW2tleV0pIHtcblx0XHRcdFx0Y2xhc3NsaXN0LnB1c2goa2V5KTtcblx0XHRcdH1cblx0XHR9XG5cblx0XHRhdHRycy5jbGFzcyA9IGNsYXNzbGlzdC5qb2luKCcgJyk7XG5cdH1cblxuXHRsZXQgYXR0cl9zdHIgPSAnJztcblx0bGV0IG5hbWU7XG5cblx0Y29uc3QgaXNfaHRtbCA9IChmbGFncyAmIEVMRU1FTlRfSVNfTkFNRVNQQUNFRCkgPT09IDA7XG5cdGNvbnN0IGxvd2VyY2FzZSA9IChmbGFncyAmIEVMRU1FTlRfUFJFU0VSVkVfQVRUUklCVVRFX0NBU0UpID09PSAwO1xuXG5cdGZvciAobmFtZSBpbiBhdHRycykge1xuXHRcdC8vIG9taXQgZnVuY3Rpb25zLCBpbnRlcm5hbCBzdmVsdGUgcHJvcGVydGllcyBhbmQgaW52YWxpZCBhdHRyaWJ1dGUgbmFtZXNcblx0XHRpZiAodHlwZW9mIGF0dHJzW25hbWVdID09PSAnZnVuY3Rpb24nKSBjb250aW51ZTtcblx0XHRpZiAobmFtZVswXSA9PT0gJyQnICYmIG5hbWVbMV0gPT09ICckJykgY29udGludWU7IC8vIGZhc3RlciB0aGFuIG5hbWUuc3RhcnRzV2l0aCgnJCQnKVxuXHRcdGlmIChJTlZBTElEX0FUVFJfTkFNRV9DSEFSX1JFR0VYLnRlc3QobmFtZSkpIGNvbnRpbnVlO1xuXG5cdFx0dmFyIHZhbHVlID0gYXR0cnNbbmFtZV07XG5cblx0XHRpZiAobG93ZXJjYXNlKSB7XG5cdFx0XHRuYW1lID0gbmFtZS50b0xvd2VyQ2FzZSgpO1xuXHRcdH1cblxuXHRcdGF0dHJfc3RyICs9IGF0dHIobmFtZSwgdmFsdWUsIGlzX2h0bWwgJiYgaXNfYm9vbGVhbl9hdHRyaWJ1dGUobmFtZSkpO1xuXHR9XG5cblx0cmV0dXJuIGF0dHJfc3RyO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgdW5rbm93bj5bXX0gcHJvcHNcbiAqIEByZXR1cm5zIHtSZWNvcmQ8c3RyaW5nLCB1bmtub3duPn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHNwcmVhZF9wcm9wcyhwcm9wcykge1xuXHQvKiogQHR5cGUge1JlY29yZDxzdHJpbmcsIHVua25vd24+fSAqL1xuXHRjb25zdCBtZXJnZWRfcHJvcHMgPSB7fTtcblx0bGV0IGtleTtcblxuXHRmb3IgKGxldCBpID0gMDsgaSA8IHByb3BzLmxlbmd0aDsgaSsrKSB7XG5cdFx0Y29uc3Qgb2JqID0gcHJvcHNbaV07XG5cdFx0Zm9yIChrZXkgaW4gb2JqKSB7XG5cdFx0XHRjb25zdCBkZXNjID0gT2JqZWN0LmdldE93blByb3BlcnR5RGVzY3JpcHRvcihvYmosIGtleSk7XG5cdFx0XHRpZiAoZGVzYykge1xuXHRcdFx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkobWVyZ2VkX3Byb3BzLCBrZXksIGRlc2MpO1xuXHRcdFx0fSBlbHNlIHtcblx0XHRcdFx0bWVyZ2VkX3Byb3BzW2tleV0gPSBvYmpba2V5XTtcblx0XHRcdH1cblx0XHR9XG5cdH1cblx0cmV0dXJuIG1lcmdlZF9wcm9wcztcbn1cblxuLyoqXG4gKiBAcGFyYW0ge3Vua25vd259IHZhbHVlXG4gKiBAcmV0dXJucyB7c3RyaW5nfVxuICovXG5leHBvcnQgZnVuY3Rpb24gc3RyaW5naWZ5KHZhbHVlKSB7XG5cdHJldHVybiB0eXBlb2YgdmFsdWUgPT09ICdzdHJpbmcnID8gdmFsdWUgOiB2YWx1ZSA9PSBudWxsID8gJycgOiB2YWx1ZSArICcnO1xufVxuXG4vKiogQHBhcmFtIHtSZWNvcmQ8c3RyaW5nLCBzdHJpbmc+fSBzdHlsZV9vYmplY3QgKi9cbmZ1bmN0aW9uIHN0eWxlX29iamVjdF90b19zdHJpbmcoc3R5bGVfb2JqZWN0KSB7XG5cdHJldHVybiBPYmplY3Qua2V5cyhzdHlsZV9vYmplY3QpXG5cdFx0LmZpbHRlcigvKiogQHBhcmFtIHthbnl9IGtleSAqLyAoa2V5KSA9PiBzdHlsZV9vYmplY3Rba2V5XSAhPSBudWxsICYmIHN0eWxlX29iamVjdFtrZXldICE9PSAnJylcblx0XHQubWFwKC8qKiBAcGFyYW0ge2FueX0ga2V5ICovIChrZXkpID0+IGAke2tleX06ICR7ZXNjYXBlX2h0bWwoc3R5bGVfb2JqZWN0W2tleV0sIHRydWUpfTtgKVxuXHRcdC5qb2luKCcgJyk7XG59XG5cbi8qKiBAcGFyYW0ge1JlY29yZDxzdHJpbmcsIHN0cmluZz59IHN0eWxlX29iamVjdCAqL1xuZXhwb3J0IGZ1bmN0aW9uIGFkZF9zdHlsZXMoc3R5bGVfb2JqZWN0KSB7XG5cdGNvbnN0IHN0eWxlcyA9IHN0eWxlX29iamVjdF90b19zdHJpbmcoc3R5bGVfb2JqZWN0KTtcblx0cmV0dXJuIHN0eWxlcyA/IGAgc3R5bGU9XCIke3N0eWxlc31cImAgOiAnJztcbn1cblxuLyoqXG4gKiBAcGFyYW0ge3N0cmluZ30gYXR0cmlidXRlXG4gKiBAcGFyYW0ge1JlY29yZDxzdHJpbmcsIHN0cmluZz59IHN0eWxlc1xuICovXG5leHBvcnQgZnVuY3Rpb24gbWVyZ2Vfc3R5bGVzKGF0dHJpYnV0ZSwgc3R5bGVzKSB7XG5cdC8qKiBAdHlwZSB7UmVjb3JkPHN0cmluZywgc3RyaW5nPn0gKi9cblx0dmFyIG1lcmdlZCA9IHt9O1xuXG5cdGlmIChhdHRyaWJ1dGUpIHtcblx0XHRmb3IgKHZhciBkZWNsYXJhdGlvbiBvZiBhdHRyaWJ1dGUuc3BsaXQoJzsnKSkge1xuXHRcdFx0dmFyIGkgPSBkZWNsYXJhdGlvbi5pbmRleE9mKCc6Jyk7XG5cdFx0XHR2YXIgbmFtZSA9IGRlY2xhcmF0aW9uLnNsaWNlKDAsIGkpLnRyaW0oKTtcblx0XHRcdHZhciB2YWx1ZSA9IGRlY2xhcmF0aW9uLnNsaWNlKGkgKyAxKS50cmltKCk7XG5cblx0XHRcdGlmIChuYW1lICE9PSAnJykgbWVyZ2VkW25hbWVdID0gdmFsdWU7XG5cdFx0fVxuXHR9XG5cblx0Zm9yIChuYW1lIGluIHN0eWxlcykge1xuXHRcdG1lcmdlZFtuYW1lXSA9IHN0eWxlc1tuYW1lXTtcblx0fVxuXG5cdHJldHVybiBtZXJnZWQ7XG59XG5cbi8qKlxuICogQHRlbXBsYXRlIFZcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgW2FueSwgYW55LCBhbnldPn0gc3RvcmVfdmFsdWVzXG4gKiBAcGFyYW0ge3N0cmluZ30gc3RvcmVfbmFtZVxuICogQHBhcmFtIHtTdG9yZTxWPiB8IG51bGwgfCB1bmRlZmluZWR9IHN0b3JlXG4gKiBAcmV0dXJucyB7Vn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHN0b3JlX2dldChzdG9yZV92YWx1ZXMsIHN0b3JlX25hbWUsIHN0b3JlKSB7XG5cdGlmIChERVYpIHtcblx0XHR2YWxpZGF0ZV9zdG9yZShzdG9yZSwgc3RvcmVfbmFtZS5zbGljZSgxKSk7XG5cdH1cblxuXHQvLyBpdCBjb3VsZCBiZSB0aGF0IHNvbWVvbmUgZWFnZXJseSB1cGRhdGVzIHRoZSBzdG9yZSBpbiB0aGUgaW5zdGFuY2Ugc2NyaXB0LCBzb1xuXHQvLyB3ZSBzaG91bGQgb25seSByZXVzZSB0aGUgc3RvcmUgdmFsdWUgaW4gdGhlIHRlbXBsYXRlXG5cdGlmIChzdG9yZV9uYW1lIGluIHN0b3JlX3ZhbHVlcyAmJiBzdG9yZV92YWx1ZXNbc3RvcmVfbmFtZV1bMF0gPT09IHN0b3JlKSB7XG5cdFx0cmV0dXJuIHN0b3JlX3ZhbHVlc1tzdG9yZV9uYW1lXVsyXTtcblx0fVxuXG5cdHN0b3JlX3ZhbHVlc1tzdG9yZV9uYW1lXT8uWzFdKCk7IC8vIGlmIHN0b3JlIHdhcyBzd2l0Y2hlZCwgdW5zdWJzY3JpYmUgZnJvbSBvbGQgc3RvcmVcblx0c3RvcmVfdmFsdWVzW3N0b3JlX25hbWVdID0gW3N0b3JlLCBudWxsLCB1bmRlZmluZWRdO1xuXHRjb25zdCB1bnN1YiA9IHN1YnNjcmliZV90b19zdG9yZShcblx0XHRzdG9yZSxcblx0XHQvKiogQHBhcmFtIHthbnl9IHYgKi8gKHYpID0+IChzdG9yZV92YWx1ZXNbc3RvcmVfbmFtZV1bMl0gPSB2KVxuXHQpO1xuXHRzdG9yZV92YWx1ZXNbc3RvcmVfbmFtZV1bMV0gPSB1bnN1Yjtcblx0cmV0dXJuIHN0b3JlX3ZhbHVlc1tzdG9yZV9uYW1lXVsyXTtcbn1cblxuLyoqXG4gKiBTZXRzIHRoZSBuZXcgdmFsdWUgb2YgYSBzdG9yZSBhbmQgcmV0dXJucyB0aGF0IHZhbHVlLlxuICogQHRlbXBsYXRlIFZcbiAqIEBwYXJhbSB7U3RvcmU8Vj59IHN0b3JlXG4gKiBAcGFyYW0ge1Z9IHZhbHVlXG4gKiBAcmV0dXJucyB7Vn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHN0b3JlX3NldChzdG9yZSwgdmFsdWUpIHtcblx0c3RvcmUuc2V0KHZhbHVlKTtcblx0cmV0dXJuIHZhbHVlO1xufVxuXG4vKipcbiAqIFVwZGF0ZXMgYSBzdG9yZSB3aXRoIGEgbmV3IHZhbHVlLlxuICogQHRlbXBsYXRlIFZcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgW2FueSwgYW55LCBhbnldPn0gc3RvcmVfdmFsdWVzXG4gKiBAcGFyYW0ge3N0cmluZ30gc3RvcmVfbmFtZVxuICogQHBhcmFtIHtTdG9yZTxWPn0gc3RvcmVcbiAqIEBwYXJhbSB7YW55fSBleHByZXNzaW9uXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzdG9yZV9tdXRhdGUoc3RvcmVfdmFsdWVzLCBzdG9yZV9uYW1lLCBzdG9yZSwgZXhwcmVzc2lvbikge1xuXHRzdG9yZV9zZXQoc3RvcmUsIHN0b3JlX2dldChzdG9yZV92YWx1ZXMsIHN0b3JlX25hbWUsIHN0b3JlKSk7XG5cdHJldHVybiBleHByZXNzaW9uO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgW2FueSwgYW55LCBhbnldPn0gc3RvcmVfdmFsdWVzXG4gKiBAcGFyYW0ge3N0cmluZ30gc3RvcmVfbmFtZVxuICogQHBhcmFtIHtTdG9yZTxudW1iZXI+fSBzdG9yZVxuICogQHBhcmFtIHsxIHwgLTF9IFtkXVxuICogQHJldHVybnMge251bWJlcn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHVwZGF0ZV9zdG9yZShzdG9yZV92YWx1ZXMsIHN0b3JlX25hbWUsIHN0b3JlLCBkID0gMSkge1xuXHRsZXQgc3RvcmVfdmFsdWUgPSBzdG9yZV9nZXQoc3RvcmVfdmFsdWVzLCBzdG9yZV9uYW1lLCBzdG9yZSk7XG5cdHN0b3JlLnNldChzdG9yZV92YWx1ZSArIGQpO1xuXHRyZXR1cm4gc3RvcmVfdmFsdWU7XG59XG5cbi8qKlxuICogQHBhcmFtIHtSZWNvcmQ8c3RyaW5nLCBbYW55LCBhbnksIGFueV0+fSBzdG9yZV92YWx1ZXNcbiAqIEBwYXJhbSB7c3RyaW5nfSBzdG9yZV9uYW1lXG4gKiBAcGFyYW0ge1N0b3JlPG51bWJlcj59IHN0b3JlXG4gKiBAcGFyYW0gezEgfCAtMX0gW2RdXG4gKiBAcmV0dXJucyB7bnVtYmVyfVxuICovXG5leHBvcnQgZnVuY3Rpb24gdXBkYXRlX3N0b3JlX3ByZShzdG9yZV92YWx1ZXMsIHN0b3JlX25hbWUsIHN0b3JlLCBkID0gMSkge1xuXHRjb25zdCB2YWx1ZSA9IHN0b3JlX2dldChzdG9yZV92YWx1ZXMsIHN0b3JlX25hbWUsIHN0b3JlKSArIGQ7XG5cdHN0b3JlLnNldCh2YWx1ZSk7XG5cdHJldHVybiB2YWx1ZTtcbn1cblxuLyoqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgW2FueSwgYW55LCBhbnldPn0gc3RvcmVfdmFsdWVzICovXG5leHBvcnQgZnVuY3Rpb24gdW5zdWJzY3JpYmVfc3RvcmVzKHN0b3JlX3ZhbHVlcykge1xuXHRmb3IgKGNvbnN0IHN0b3JlX25hbWUgaW4gc3RvcmVfdmFsdWVzKSB7XG5cdFx0c3RvcmVfdmFsdWVzW3N0b3JlX25hbWVdWzFdKCk7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge1BheWxvYWR9IHBheWxvYWRcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgYW55Pn0gJCRwcm9wc1xuICogQHBhcmFtIHtzdHJpbmd9IG5hbWVcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgdW5rbm93bj59IHNsb3RfcHJvcHNcbiAqIEBwYXJhbSB7bnVsbCB8ICgoKSA9PiB2b2lkKX0gZmFsbGJhY2tfZm5cbiAqIEByZXR1cm5zIHt2b2lkfVxuICovXG5leHBvcnQgZnVuY3Rpb24gc2xvdChwYXlsb2FkLCAkJHByb3BzLCBuYW1lLCBzbG90X3Byb3BzLCBmYWxsYmFja19mbikge1xuXHR2YXIgc2xvdF9mbiA9ICQkcHJvcHMuJCRzbG90cz8uW25hbWVdO1xuXHQvLyBJbnRlcm9wOiBDYW4gdXNlIHNuaXBwZXRzIHRvIGZpbGwgc2xvdHNcblx0aWYgKHNsb3RfZm4gPT09IHRydWUpIHtcblx0XHRzbG90X2ZuID0gJCRwcm9wc1tuYW1lID09PSAnZGVmYXVsdCcgPyAnY2hpbGRyZW4nIDogbmFtZV07XG5cdH1cblxuXHRpZiAoc2xvdF9mbiAhPT0gdW5kZWZpbmVkKSB7XG5cdFx0c2xvdF9mbihwYXlsb2FkLCBzbG90X3Byb3BzKTtcblx0fSBlbHNlIHtcblx0XHRmYWxsYmFja19mbj8uKCk7XG5cdH1cbn1cblxuLyoqXG4gKiBAcGFyYW0ge1JlY29yZDxzdHJpbmcsIHVua25vd24+fSBwcm9wc1xuICogQHBhcmFtIHtzdHJpbmdbXX0gcmVzdFxuICogQHJldHVybnMge1JlY29yZDxzdHJpbmcsIHVua25vd24+fVxuICovXG5leHBvcnQgZnVuY3Rpb24gcmVzdF9wcm9wcyhwcm9wcywgcmVzdCkge1xuXHQvKiogQHR5cGUge1JlY29yZDxzdHJpbmcsIHVua25vd24+fSAqL1xuXHRjb25zdCByZXN0X3Byb3BzID0ge307XG5cdGxldCBrZXk7XG5cdGZvciAoa2V5IGluIHByb3BzKSB7XG5cdFx0aWYgKCFyZXN0LmluY2x1ZGVzKGtleSkpIHtcblx0XHRcdHJlc3RfcHJvcHNba2V5XSA9IHByb3BzW2tleV07XG5cdFx0fVxuXHR9XG5cdHJldHVybiByZXN0X3Byb3BzO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgdW5rbm93bj59IHByb3BzXG4gKiBAcmV0dXJucyB7UmVjb3JkPHN0cmluZywgdW5rbm93bj59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBzYW5pdGl6ZV9wcm9wcyhwcm9wcykge1xuXHRjb25zdCB7IGNoaWxkcmVuLCAkJHNsb3RzLCAuLi5zYW5pdGl6ZWQgfSA9IHByb3BzO1xuXHRyZXR1cm4gc2FuaXRpemVkO1xufVxuXG4vKipcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgYW55Pn0gcHJvcHNcbiAqIEByZXR1cm5zIHtSZWNvcmQ8c3RyaW5nLCBib29sZWFuPn1cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIHNhbml0aXplX3Nsb3RzKHByb3BzKSB7XG5cdC8qKiBAdHlwZSB7UmVjb3JkPHN0cmluZywgYm9vbGVhbj59ICovXG5cdGNvbnN0IHNhbml0aXplZCA9IHt9O1xuXHRpZiAocHJvcHMuY2hpbGRyZW4pIHNhbml0aXplZC5kZWZhdWx0ID0gdHJ1ZTtcblx0Zm9yIChjb25zdCBrZXkgaW4gcHJvcHMuJCRzbG90cykge1xuXHRcdHNhbml0aXplZFtrZXldID0gdHJ1ZTtcblx0fVxuXHRyZXR1cm4gc2FuaXRpemVkO1xufVxuXG4vKipcbiAqIExlZ2FjeSBtb2RlOiBJZiB0aGUgcHJvcCBoYXMgYSBmYWxsYmFjayBhbmQgaXMgYm91bmQgaW4gdGhlXG4gKiBwYXJlbnQgY29tcG9uZW50LCBwcm9wYWdhdGUgdGhlIGZhbGxiYWNrIHZhbHVlIHVwd2FyZHMuXG4gKiBAcGFyYW0ge1JlY29yZDxzdHJpbmcsIHVua25vd24+fSBwcm9wc19wYXJlbnRcbiAqIEBwYXJhbSB7UmVjb3JkPHN0cmluZywgdW5rbm93bj59IHByb3BzX25vd1xuICovXG5leHBvcnQgZnVuY3Rpb24gYmluZF9wcm9wcyhwcm9wc19wYXJlbnQsIHByb3BzX25vdykge1xuXHRmb3IgKGNvbnN0IGtleSBpbiBwcm9wc19ub3cpIHtcblx0XHRjb25zdCBpbml0aWFsX3ZhbHVlID0gcHJvcHNfcGFyZW50W2tleV07XG5cdFx0Y29uc3QgdmFsdWUgPSBwcm9wc19ub3dba2V5XTtcblx0XHRpZiAoXG5cdFx0XHRpbml0aWFsX3ZhbHVlID09PSB1bmRlZmluZWQgJiZcblx0XHRcdHZhbHVlICE9PSB1bmRlZmluZWQgJiZcblx0XHRcdE9iamVjdC5nZXRPd25Qcm9wZXJ0eURlc2NyaXB0b3IocHJvcHNfcGFyZW50LCBrZXkpPy5zZXRcblx0XHQpIHtcblx0XHRcdHByb3BzX3BhcmVudFtrZXldID0gdmFsdWU7XG5cdFx0fVxuXHR9XG59XG5cbi8qKlxuICogQHRlbXBsYXRlIFZcbiAqIEBwYXJhbSB7UHJvbWlzZTxWPn0gcHJvbWlzZVxuICogQHBhcmFtIHtudWxsIHwgKCgpID0+IHZvaWQpfSBwZW5kaW5nX2ZuXG4gKiBAcGFyYW0geyh2YWx1ZTogVikgPT4gdm9pZH0gdGhlbl9mblxuICogQHJldHVybnMge3ZvaWR9XG4gKi9cbmZ1bmN0aW9uIGF3YWl0X2Jsb2NrKHByb21pc2UsIHBlbmRpbmdfZm4sIHRoZW5fZm4pIHtcblx0aWYgKGlzX3Byb21pc2UocHJvbWlzZSkpIHtcblx0XHRwcm9taXNlLnRoZW4obnVsbCwgbm9vcCk7XG5cdFx0aWYgKHBlbmRpbmdfZm4gIT09IG51bGwpIHtcblx0XHRcdHBlbmRpbmdfZm4oKTtcblx0XHR9XG5cdH0gZWxzZSBpZiAodGhlbl9mbiAhPT0gbnVsbCkge1xuXHRcdHRoZW5fZm4ocHJvbWlzZSk7XG5cdH1cbn1cblxuZXhwb3J0IHsgYXdhaXRfYmxvY2sgYXMgYXdhaXQgfTtcblxuLyoqIEBwYXJhbSB7YW55fSBhcnJheV9saWtlX29yX2l0ZXJhdG9yICovXG5leHBvcnQgZnVuY3Rpb24gZW5zdXJlX2FycmF5X2xpa2UoYXJyYXlfbGlrZV9vcl9pdGVyYXRvcikge1xuXHRpZiAoYXJyYXlfbGlrZV9vcl9pdGVyYXRvcikge1xuXHRcdHJldHVybiBhcnJheV9saWtlX29yX2l0ZXJhdG9yLmxlbmd0aCAhPT0gdW5kZWZpbmVkXG5cdFx0XHQ/IGFycmF5X2xpa2Vfb3JfaXRlcmF0b3Jcblx0XHRcdDogQXJyYXkuZnJvbShhcnJheV9saWtlX29yX2l0ZXJhdG9yKTtcblx0fVxuXHRyZXR1cm4gW107XG59XG5cbi8qKlxuICogQHBhcmFtIHthbnlbXX0gYXJnc1xuICogQHBhcmFtIHtGdW5jdGlvbn0gW2luc3BlY3RdXG4gKi9cbi8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1jb25zb2xlXG5leHBvcnQgZnVuY3Rpb24gaW5zcGVjdChhcmdzLCBpbnNwZWN0ID0gY29uc29sZS5sb2cpIHtcblx0aW5zcGVjdCgnaW5pdCcsIC4uLmFyZ3MpO1xufVxuXG4vKipcbiAqIEB0ZW1wbGF0ZSBWXG4gKiBAcGFyYW0geygpID0+IFZ9IGdldF92YWx1ZVxuICovXG5leHBvcnQgZnVuY3Rpb24gb25jZShnZXRfdmFsdWUpIHtcblx0bGV0IHZhbHVlID0gLyoqIEB0eXBlIHtWfSAqLyAoVU5JTklUSUFMSVpFRCk7XG5cdHJldHVybiAoKSA9PiB7XG5cdFx0aWYgKHZhbHVlID09PSBVTklOSVRJQUxJWkVEKSB7XG5cdFx0XHR2YWx1ZSA9IGdldF92YWx1ZSgpO1xuXHRcdH1cblx0XHRyZXR1cm4gdmFsdWU7XG5cdH07XG59XG5cbi8qKlxuICogQ3JlYXRlIGFuIHVuaXF1ZSBJRFxuICogQHBhcmFtIHtQYXlsb2FkfSBwYXlsb2FkXG4gKiBAcmV0dXJucyB7c3RyaW5nfVxuICovXG5leHBvcnQgZnVuY3Rpb24gcHJvcHNfaWQocGF5bG9hZCkge1xuXHRjb25zdCB1aWQgPSBwYXlsb2FkLnVpZCgpO1xuXHRwYXlsb2FkLm91dCArPSAnPCEtLSMnICsgdWlkICsgJy0tPic7XG5cdHJldHVybiB1aWQ7XG59XG5cbmV4cG9ydCB7IGF0dHIsIGNsc3ggfTtcblxuZXhwb3J0IHsgaHRtbCB9IGZyb20gJy4vYmxvY2tzL2h0bWwuanMnO1xuXG5leHBvcnQgeyBwdXNoLCBwb3AgfSBmcm9tICcuL2NvbnRleHQuanMnO1xuXG5leHBvcnQgeyBwdXNoX2VsZW1lbnQsIHBvcF9lbGVtZW50IH0gZnJvbSAnLi9kZXYuanMnO1xuXG5leHBvcnQgeyBzbmFwc2hvdCB9IGZyb20gJy4uL3NoYXJlZC9jbG9uZS5qcyc7XG5cbmV4cG9ydCB7IGZhbGxiYWNrIH0gZnJvbSAnLi4vc2hhcmVkL3V0aWxzLmpzJztcblxuZXhwb3J0IHtcblx0aW52YWxpZF9kZWZhdWx0X3NuaXBwZXQsXG5cdHZhbGlkYXRlX2R5bmFtaWNfZWxlbWVudF90YWcsXG5cdHZhbGlkYXRlX3ZvaWRfZHluYW1pY19lbGVtZW50XG59IGZyb20gJy4uL3NoYXJlZC92YWxpZGF0ZS5qcyc7XG5cbmV4cG9ydCB7IGVzY2FwZV9odG1sIGFzIGVzY2FwZSB9O1xuIiwgIi8qKiBAaW1wb3J0IHsgU25pcHBldCB9IGZyb20gJ3N2ZWx0ZScgKi9cbi8qKiBAaW1wb3J0IHsgUGF5bG9hZCB9IGZyb20gJyNzZXJ2ZXInICovXG4vKiogQGltcG9ydCB7IEdldHRlcnMgfSBmcm9tICcjc2hhcmVkJyAqL1xuXG4vKipcbiAqIENyZWF0ZSBhIHNuaXBwZXQgcHJvZ3JhbW1hdGljYWxseVxuICogQHRlbXBsYXRlIHt1bmtub3duW119IFBhcmFtc1xuICogQHBhcmFtIHsoLi4ucGFyYW1zOiBHZXR0ZXJzPFBhcmFtcz4pID0+IHtcbiAqICAgcmVuZGVyOiAoKSA9PiBzdHJpbmdcbiAqICAgc2V0dXA/OiAoZWxlbWVudDogRWxlbWVudCkgPT4gdm9pZCB8ICgoKSA9PiB2b2lkKVxuICogfX0gZm5cbiAqIEByZXR1cm5zIHtTbmlwcGV0PFBhcmFtcz59XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjcmVhdGVSYXdTbmlwcGV0KGZuKSB7XG5cdC8vIEB0cy1leHBlY3QtZXJyb3IgdGhlIHR5cGVzIGFyZSBhIGxpZVxuXHRyZXR1cm4gKC8qKiBAdHlwZSB7UGF5bG9hZH0gKi8gcGF5bG9hZCwgLyoqIEB0eXBlIHtQYXJhbXN9ICovIC4uLmFyZ3MpID0+IHtcblx0XHR2YXIgZ2V0dGVycyA9IC8qKiBAdHlwZSB7R2V0dGVyczxQYXJhbXM+fSAqLyAoYXJncy5tYXAoKHZhbHVlKSA9PiAoKSA9PiB2YWx1ZSkpO1xuXHRcdHBheWxvYWQub3V0ICs9IGZuKC4uLmdldHRlcnMpXG5cdFx0XHQucmVuZGVyKClcblx0XHRcdC50cmltKCk7XG5cdH07XG59XG4iLCAiZXhwb3J0IGZ1bmN0aW9uIG5vcm1hbGl6ZUNvbXBvbmVudHMoY29tcG9uZW50cykge1xuICAgIGlmICghQXJyYXkuaXNBcnJheShjb21wb25lbnRzLmRlZmF1bHQpIHx8ICFBcnJheS5pc0FycmF5KGNvbXBvbmVudHMuZmlsZW5hbWVzKSkgcmV0dXJuIGNvbXBvbmVudHNcblxuICAgIGNvbnN0IG5vcm1hbGl6ZWQgPSB7fVxuICAgIGZvciAoY29uc3QgW2luZGV4LCBtb2R1bGVdIG9mIGNvbXBvbmVudHMuZGVmYXVsdC5lbnRyaWVzKCkpIHtcbiAgICAgICAgY29uc3QgQ29tcG9uZW50ID0gbW9kdWxlLmRlZmF1bHRcbiAgICAgICAgY29uc3QgbmFtZSA9IGNvbXBvbmVudHMuZmlsZW5hbWVzW2luZGV4XS5yZXBsYWNlKFwiLi4vc3ZlbHRlL1wiLCBcIlwiKS5yZXBsYWNlKFwiLnN2ZWx0ZVwiLCBcIlwiKVxuICAgICAgICBub3JtYWxpemVkW25hbWVdID0gQ29tcG9uZW50XG4gICAgfVxuICAgIHJldHVybiBub3JtYWxpemVkXG59XG4iLCAiaW1wb3J0IHtub3JtYWxpemVDb21wb25lbnRzfSBmcm9tIFwiLi91dGlsc1wiXG5pbXBvcnQge3JlbmRlcn0gZnJvbSBcInN2ZWx0ZS9zZXJ2ZXJcIlxuaW1wb3J0IHtjcmVhdGVSYXdTbmlwcGV0fSBmcm9tIFwic3ZlbHRlXCJcblxuZXhwb3J0IGZ1bmN0aW9uIGdldFJlbmRlcihjb21wb25lbnRzKSB7XG4gICAgY29tcG9uZW50cyA9IG5vcm1hbGl6ZUNvbXBvbmVudHMoY29tcG9uZW50cylcblxuICAgIHJldHVybiBmdW5jdGlvbiByKG5hbWUsIHByb3BzLCBzbG90cykge1xuICAgICAgICBjb25zdCBzbmlwcGV0cyA9IE9iamVjdC5mcm9tRW50cmllcyhcbiAgICAgICAgICAgIE9iamVjdC5lbnRyaWVzKHNsb3RzKS5tYXAoKFtzbG90TmFtZSwgdl0pID0+IHtcbiAgICAgICAgICAgICAgICBjb25zdCBzbmlwcGV0ID0gY3JlYXRlUmF3U25pcHBldChuYW1lID0+IHtcbiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICAgICAgICAgICAgICAgIHJlbmRlcjogKCkgPT4gdixcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH0pXG4gICAgICAgICAgICAgICAgaWYgKHNsb3ROYW1lID09PSBcImRlZmF1bHRcIikgcmV0dXJuIFtcImNoaWxkcmVuXCIsIHNuaXBwZXRdXG4gICAgICAgICAgICAgICAgZWxzZSByZXR1cm4gW3Nsb3ROYW1lLCBzbmlwcGV0XVxuICAgICAgICAgICAgfSlcbiAgICAgICAgKVxuXG4gICAgICAgIHJldHVybiByZW5kZXIoY29tcG9uZW50c1tuYW1lXSwge3Byb3BzOiB7Li4ucHJvcHMsIC4uLnNuaXBwZXRzfX0pXG4gICAgfVxufVxuIiwgImltcG9ydCB7bm9ybWFsaXplQ29tcG9uZW50c30gZnJvbSBcIi4vdXRpbHNcIlxuaW1wb3J0IHttb3VudCwgaHlkcmF0ZSwgdW5tb3VudCwgY3JlYXRlUmF3U25pcHBldH0gZnJvbSBcInN2ZWx0ZVwiXG5cbmZ1bmN0aW9uIGdldEF0dHJpYnV0ZUpzb24ocmVmLCBhdHRyaWJ1dGVOYW1lKSB7XG4gICAgY29uc3QgZGF0YSA9IHJlZi5lbC5nZXRBdHRyaWJ1dGUoYXR0cmlidXRlTmFtZSlcbiAgICByZXR1cm4gZGF0YSA/IEpTT04ucGFyc2UoZGF0YSkgOiB7fVxufVxuXG5mdW5jdGlvbiBnZXRTbG90cyhyZWYpIHtcbiAgICBsZXQgc25pcHBldHMgPSB7fVxuXG4gICAgZm9yIChjb25zdCBzbG90TmFtZSBpbiBnZXRBdHRyaWJ1dGVKc29uKHJlZiwgXCJkYXRhLXNsb3RzXCIpKSB7XG4gICAgICAgIGNvbnN0IGJhc2U2NCA9IGdldEF0dHJpYnV0ZUpzb24ocmVmLCBcImRhdGEtc2xvdHNcIilbc2xvdE5hbWVdXG4gICAgICAgIGNvbnN0IGVsZW1lbnQgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KFwiZGl2XCIpXG4gICAgICAgIGVsZW1lbnQuaW5uZXJIVE1MID0gYXRvYihiYXNlNjQpLnRyaW0oKVxuXG4gICAgICAgIGNvbnN0IHNuaXBwZXQgPSBjcmVhdGVSYXdTbmlwcGV0KG5hbWUgPT4ge1xuICAgICAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICAgICAgICByZW5kZXI6ICgpID0+IGVsZW1lbnQub3V0ZXJIVE1MLFxuICAgICAgICAgICAgfVxuICAgICAgICB9KVxuXG4gICAgICAgIGlmIChzbG90TmFtZSA9PT0gXCJkZWZhdWx0XCIpIHNuaXBwZXRzW1wiY2hpbGRyZW5cIl0gPSBzbmlwcGV0XG4gICAgICAgIGVsc2Ugc25pcHBldHNbc2xvdE5hbWVdID0gc25pcHBldFxuICAgIH1cblxuICAgIHJldHVybiBzbmlwcGV0c1xufVxuXG5mdW5jdGlvbiBnZXRMaXZlSnNvblByb3BzKHJlZikge1xuICAgIGNvbnN0IGpzb24gPSBnZXRBdHRyaWJ1dGVKc29uKHJlZiwgXCJkYXRhLWxpdmUtanNvblwiKVxuXG4gICAgLy8gT24gU1NSLCBkYXRhLWxpdmUtanNvbiBpcyB0aGUgZnVsbCBvYmplY3Qgd2Ugd2FudFxuICAgIC8vIEFmdGVyIFNTUiwgZGF0YS1saXZlLWpzb24gaXMgYW4gYXJyYXkgb2Yga2V5cywgYW5kIHdlJ2xsIGdldCB0aGUgZGF0YSBmcm9tIHRoZSB3aW5kb3dcbiAgICBpZiAoIUFycmF5LmlzQXJyYXkoanNvbikpIHJldHVybiBqc29uXG5cbiAgICBjb25zdCBsaXZlSnNvbkRhdGEgPSB7fVxuICAgIGZvciAoY29uc3QgbGl2ZUpzb25WYXJpYWJsZSBvZiBqc29uKSB7XG4gICAgICAgIGNvbnN0IGRhdGEgPSB3aW5kb3dbbGl2ZUpzb25WYXJpYWJsZV1cbiAgICAgICAgaWYgKGRhdGEpIGxpdmVKc29uRGF0YVtsaXZlSnNvblZhcmlhYmxlXSA9IGRhdGFcbiAgICB9XG4gICAgcmV0dXJuIGxpdmVKc29uRGF0YVxufVxuXG5mdW5jdGlvbiBnZXRQcm9wcyhyZWYpIHtcbiAgICByZXR1cm4ge1xuICAgICAgICAuLi5nZXRBdHRyaWJ1dGVKc29uKHJlZiwgXCJkYXRhLXByb3BzXCIpLFxuICAgICAgICAuLi5nZXRMaXZlSnNvblByb3BzKHJlZiksXG4gICAgICAgIC4uLmdldFNsb3RzKHJlZiksXG4gICAgICAgIGxpdmU6IHJlZixcbiAgICB9XG59XG5cbmZ1bmN0aW9uIGZpbmRTbG90Q3R4KGNvbXBvbmVudCkge1xuICAgIC8vIFRoZSBkZWZhdWx0IHNsb3QgYWx3YXlzIGV4aXN0cyBpZiB0aGVyZSdzIGEgc2xvdCBzZXRcbiAgICAvLyBldmVuIGlmIG5vIHNsb3QgaXMgc2V0IGZvciB0aGUgZXhwbGljaXQgZGVmYXVsdCBzbG90XG4gICAgcmV0dXJuIGNvbXBvbmVudC4kJC5jdHguZmluZChjdHhFbGVtZW50ID0+IGN0eEVsZW1lbnQ/LmRlZmF1bHQpXG59XG5cbmZ1bmN0aW9uIHVwZGF0ZV9zdGF0ZShyZWYpIHtcbiAgICBjb25zdCBuZXdQcm9wcyA9IGdldFByb3BzKHJlZilcbiAgICBmb3IgKGNvbnN0IGtleSBpbiBuZXdQcm9wcykge1xuICAgICAgICByZWYuX2luc3RhbmNlLnN0YXRlW2tleV0gPSBuZXdQcm9wc1trZXldXG4gICAgfVxufVxuXG5leHBvcnQgZnVuY3Rpb24gZ2V0SG9va3MoY29tcG9uZW50cykge1xuICAgIGNvbXBvbmVudHMgPSBub3JtYWxpemVDb21wb25lbnRzKGNvbXBvbmVudHMpXG5cbiAgICBjb25zdCBTdmVsdGVIb29rID0ge1xuICAgICAgICBtb3VudGVkKCkge1xuICAgICAgICAgICAgbGV0IHN0YXRlID0gJHN0YXRlKGdldFByb3BzKHRoaXMpKVxuICAgICAgICAgICAgY29uc3QgY29tcG9uZW50TmFtZSA9IHRoaXMuZWwuZ2V0QXR0cmlidXRlKFwiZGF0YS1uYW1lXCIpXG4gICAgICAgICAgICBpZiAoIWNvbXBvbmVudE5hbWUpIHRocm93IG5ldyBFcnJvcihcIkNvbXBvbmVudCBuYW1lIG11c3QgYmUgcHJvdmlkZWRcIilcblxuICAgICAgICAgICAgY29uc3QgQ29tcG9uZW50ID0gY29tcG9uZW50c1tjb21wb25lbnROYW1lXVxuICAgICAgICAgICAgaWYgKCFDb21wb25lbnQpIHRocm93IG5ldyBFcnJvcihgVW5hYmxlIHRvIGZpbmQgJHtjb21wb25lbnROYW1lfSBjb21wb25lbnQuYClcblxuICAgICAgICAgICAgZm9yIChjb25zdCBsaXZlSnNvbkVsZW1lbnQgb2YgT2JqZWN0LmtleXMoZ2V0QXR0cmlidXRlSnNvbih0aGlzLCBcImRhdGEtbGl2ZS1qc29uXCIpKSkge1xuICAgICAgICAgICAgICAgIHdpbmRvdy5hZGRFdmVudExpc3RlbmVyKGAke2xpdmVKc29uRWxlbWVudH1faW5pdGlhbGl6ZWRgLCBfZXZlbnQgPT4gdXBkYXRlX3N0YXRlKHRoaXMpLCBmYWxzZSlcbiAgICAgICAgICAgICAgICB3aW5kb3cuYWRkRXZlbnRMaXN0ZW5lcihgJHtsaXZlSnNvbkVsZW1lbnR9X3BhdGNoZWRgLCBfZXZlbnQgPT4gdXBkYXRlX3N0YXRlKHRoaXMpLCBmYWxzZSlcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgY29uc3QgaHlkcmF0ZU9yTW91bnQgPSB0aGlzLmVsLmhhc0F0dHJpYnV0ZShcImRhdGEtc3NyXCIpID8gaHlkcmF0ZSA6IG1vdW50XG5cbiAgICAgICAgICAgIHRoaXMuX2luc3RhbmNlID0gaHlkcmF0ZU9yTW91bnQoQ29tcG9uZW50LCB7XG4gICAgICAgICAgICAgICAgdGFyZ2V0OiB0aGlzLmVsLFxuICAgICAgICAgICAgICAgIHByb3BzOiBzdGF0ZSxcbiAgICAgICAgICAgIH0pXG4gICAgICAgICAgICB0aGlzLl9pbnN0YW5jZS5zdGF0ZSA9IHN0YXRlXG4gICAgICAgIH0sXG5cbiAgICAgICAgdXBkYXRlZCgpIHtcbiAgICAgICAgICAgIHVwZGF0ZV9zdGF0ZSh0aGlzKVxuICAgICAgICB9LFxuXG4gICAgICAgIGRlc3Ryb3llZCgpIHtcbiAgICAgICAgICAgIGlmICh0aGlzLl9pbnN0YW5jZSkgd2luZG93LmFkZEV2ZW50TGlzdGVuZXIoXCJwaHg6cGFnZS1sb2FkaW5nLXN0b3BcIiwgKCkgPT4gdW5tb3VudCh0aGlzLl9pbnN0YW5jZSksIHtvbmNlOiB0cnVlfSlcbiAgICAgICAgfSxcbiAgICB9XG5cbiAgICByZXR1cm4ge1xuICAgICAgICBTdmVsdGVIb29rLFxuICAgIH1cbn1cbiJdLAogICJtYXBwaW5ncyI6ICI7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBQUEsSUFBQUEsa0JBQUE7QUFBQSxTQUFBQSxpQkFBQTtBQUFBLGdCQUFBQztBQUFBO0FBQUEsOEJBQUFEOzs7QUNBQTtBQUFBO0FBQUE7QUFBQTtBQUFBO0E7Ozs7Ozs7O0FDQ08sSUFBTSxzQkFBc0IsS0FBSztBQUVqQyxJQUFNLHFCQUFxQixLQUFLO0FBQ2hDLElBQU0sbUJBQW1CLEtBQUs7QUFDOUIsSUFBTSxzQkFBc0IsS0FBSztBQUdqQyxJQUFNLGlCQUFpQixLQUFLO0FBQzVCLElBQU0sbUJBQW1CLEtBQUs7QUFDOUIsSUFBTSxvQkFBb0IsS0FBSztBQUMvQixJQUFNLHdCQUF3QixLQUFLO0FBR25DLElBQU0saUJBQWlCLEtBQUs7QUFDNUIsSUFBTSxvQkFBb0IsS0FBSztBQUcvQixJQUFNLDJCQUEyQixLQUFLO0FBRXRDLElBQU0sa0JBQWtCO0FBRXhCLElBQU0sdUJBQXVCO0FBQzdCLElBQU0sZ0JBQWdCO0FBQ3RCLElBQU0sa0JBQWtCLENBQUM7QUFHekIsSUFBTSxrQ0FBa0MsS0FBSztBQUU3QyxJQUFNLGdCQUFnQixPQUFPO0FBRzdCLElBQU0sV0FBVyxPQUFPLFVBQVU7QUFDbEMsSUFBTSxNQUFNLE9BQU8sS0FBSzs7O0FDakMvQixJQUFNLGFBQWE7QUFDbkIsSUFBTSxnQkFBZ0I7QUFPZixTQUFTLFlBQVksT0FBTyxTQUFTO0FBQzNDLFFBQU0sTUFBTSxPQUFPLFNBQVMsRUFBRTtBQUU5QixRQUFNLFVBQVUsVUFBVSxhQUFhO0FBQ3ZDLFVBQVEsWUFBWTtBQUVwQixNQUFJLFVBQVU7QUFDZCxNQUFJLE9BQU87QUFFWCxTQUFPLFFBQVEsS0FBSyxHQUFHLEdBQUc7QUFDekIsVUFBTSxJQUFJLFFBQVEsWUFBWTtBQUM5QixVQUFNLEtBQUssSUFB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RUFBRSxJQUFJLENBQUMsQ0FBQyxVQUFVLENBQUMsTUFBTTtBQUN6QyxjQUFNRSxXQUFVQyxrQkFBaUIsQ0FBQUMsVUFBUTtBQUNyQyxpQkFBTztZQUNILFFBQVEsTUFBTTtVQUNsQjtRQUNKLENBQUM7QUFDRCxZQUFJLGFBQWEsVUFBVyxRQUFPLENBQUMsWUFBWUYsUUFBTztZQUNsRCxRQUFPLENBQUMsVUFBVUEsUUFBTztNQUNsQyxDQUFDO0lBQ0w7QUFFQSxXQUFPLE9BQU8sV0FBVyxJQUFJLEdBQUcsRUFBQyxPQUFPLEVBQUMsR0FBRyxPQUFPLEdBQUcsU0FBUSxFQUFDLENBQUM7RUFDcEU7QUFDSjs7O0F2Q25CTyxJQUFNRyxVQUFTLFVBQVUsU0FBVTsiLAogICJuYW1lcyI6IFsic2VydmVyX2V4cG9ydHMiLCAicmVuZGVyIiwgImZhbGxiYWNrIiwgInN0YWNrIiwgImNvbXBvbmVudCIsICJzdGFjayIsICJzb3VyY2UiLCAiZWZmZWN0IiwgImFycmF5X3Byb3RvdHlwZSIsICJpbmRleCIsICJkZXJpdmVkIiwgInBhcmVudCIsICJlZmZlY3QiLCAicHVzaCIsICJkZXJpdmVkIiwgImVmZmVjdCIsICJwdXNoIiwgImVmZmVjdCIsICJ0ZWFyZG93biIsICJuZXh0IiwgInRyYW5zaXRpb24iLCAicGFyZW50IiwgImNoaWxkIiwgInNpYmxpbmciLCAiaXNfbWljcm9fdGFza19xdWV1ZWQiLCAiZWZmZWN0IiwgImRlcml2ZWQiLCAicGFyZW50IiwgImVmZmVjdCIsICJlZmZlY3QiLCAiY29tcG9uZW50X2NvbnRleHQiLCAic3RhY2siLCAiaW5kZXgiLCAidGVhcmRvd24iLCAiaXNfbWljcm9fdGFza19xdWV1ZWQiLCAic2libGluZyIsICJjaGlsZCIsICJwYXJlbnQiLCAiZGVyaXZlZCIsICJwYXJlbnQiLCAiZXZlbnQiLCAiZWZmZWN0IiwgImNvbXBvbmVudCIsICJldmVudHMiLCAicGFzc2l2ZSIsICJ1bm1vdW50IiwgInByb3AiLCAibmV4dCIsICJldmVudCIsICJjcmVhdGVfc2xvdCIsICJzbG90IiwgImF0dHIiLCAicHJvcCIsICJlbGVtZW50IiwgInRocm93X3J1bmVfZXJyb3IiLCAicHVzaCIsICJwb3AiLCAiY29tcG9uZW50IiwgImNoaWxkIiwgInBhcmVudCIsICJjaGlsZCIsICJtZXNzYWdlIiwgImNvbXBvbmVudCIsICJwdXNoIiwgInBvcCIsICJoZWFkIiwgImhhc2giLCAiY3JlYXRlUmF3U25pcHBldCIsICJpbmRleCIsICJtb2R1bGUiLCAic25pcHBldCIsICJjcmVhdGVSYXdTbmlwcGV0IiwgIm5hbWUiLCAicmVuZGVyIl0KfQo=
