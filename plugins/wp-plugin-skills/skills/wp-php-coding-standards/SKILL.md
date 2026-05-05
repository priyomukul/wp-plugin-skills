---
name: wp-php-coding-standards
description: WordPress Coding Standards (WPCS) for PHP — formatting, naming, prefixing, file headers, Yoda conditions, spacing, brace style, and PHPDoc rules from developer.wordpress.org/coding-standards. Use this skill whenever writing or reviewing PHP files in a WordPress plugin or theme — it complements wp-plugin-development (which covers architecture/security) and wp-phpstan (which covers static analysis) but those skills do not cover WPCS *style*. Trigger this skill on any PHP file inside wp-content/plugins/, wp-content/themes/, or any file with a WordPress plugin/theme header, even when the user does not explicitly mention "coding standards" or "WPCS".
---

# WordPress Coding Standards (PHP)

Source: https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/

This skill covers WPCS *style*: how PHP files should be formatted, named, and documented in a
WordPress codebase. It complements but does not duplicate:

- `wp-plugin-development` — plugin architecture, hooks, lifecycle, security
- `wp-plugin-directory-guidelines` — WordPress.org submission rules
- `wp-phpstan` — static analysis (a separate concern from style)

If your task is "what should this file look like," you're in the right place. If it's "how should
this plugin be organized" or "is this code secure enough for the plugin directory," route to the
upstream skills above.

## File headers

### Main plugin file (one per plugin)

```php
<?php
/**
 * Plugin Name:       Acme Widgets
 * Plugin URI:        https://example.com/acme-widgets
 * Description:       Adds Acme widgets to your site.
 * Version:           1.0.0
 * Requires at least: 6.4
 * Requires PHP:      7.4
 * Author:            Acme Inc.
 * Author URI:        https://example.com
 * License:           GPL-2.0-or-later
 * License URI:       https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain:       acme-widgets
 * Domain Path:       /languages
 *
 * @package AcmeWidgets
 */

defined( 'ABSPATH' ) || exit;
```

- Headers are case-sensitive; use `Field Name: value` on its own line.
- `Text Domain` MUST equal the plugin slug (the WordPress.org folder name).
- Always guard direct access with `defined( 'ABSPATH' ) || exit;` at the top of every PHP file.

### Other PHP files

```php
<?php
/**
 * Short description of what this file contains.
 *
 * @package AcmeWidgets
 */

defined( 'ABSPATH' ) || exit;
```

## Naming

| Thing | Convention | Example |
|---|---|---|
| Functions | lowercase, underscores, prefixed | `acme_widgets_register_post_type()` |
| Variables | lowercase, underscores | `$post_id`, `$user_email` |
| Classes | PascalCase or namespaced, prefixed | `AcmeWidgets_Settings`, `AcmeWidgets\Settings` |
| Constants | UPPER_SNAKE_CASE, prefixed | `ACME_WIDGETS_VERSION` |
| Hooks (actions/filters) | lowercase, underscores, prefixed | `do_action( 'acme_widgets_after_save', $id );` |
| Options/transients | lowercase, underscores, prefixed | `acme_widgets_settings` |
| Meta keys | underscore prefix marks "private" | `_acme_widgets_price` |
| CSS/JS handles | lowercase, hyphens, prefixed | `acme-widgets-admin` |
| Post types / taxonomies | lowercase, hyphens or underscores, prefixed, ≤ 20 chars | `acme_widget`, `acme_widget_cat` |
| REST namespaces | `vendor/v1` form, prefixed | `acme-widgets/v1` |
| Files | lowercase, hyphens, `class-` prefix for classes | `class-acme-widgets-settings.php` |

### Prefixing rule

Every public symbol must start with a unique 3+ character slug. Generic names are rejected by
the WordPress.org Plugin Directory and cause runtime collisions in shared sites.

Bad:

```php
function init() {}                                       // collides with hundreds of plugins
class Settings {}                                        // PHP fatal if another plugin has it
const VERSION = '1.0';                                   // collides
$wpdb->get_var( "SELECT * FROM data" );                  // 'data' is not your table
```

Good:

```php
function acme_widgets_init() {}
class AcmeWidgets_Settings {}
const ACME_WIDGETS_VERSION = '1.0';
$wpdb->get_var( "SELECT * FROM {$wpdb->prefix}acme_widgets" );
```

A namespaced class (`namespace AcmeWidgets;`) counts as prefixed because the FQN is unique.

## Spacing & braces

- **Indentation**: real tabs (not spaces). Align with spaces only inside an already-tab-indented line.
- Always use braces, even for single-line `if`:
  ```php
  if ( $ready ) {
      do_thing();
  }
  ```
- **Spaces inside parentheses** for control structures and function calls:
  ```php
  if ( $foo && ( $bar || $baz ) ) { ... }
  my_function( $arg1, $arg2 );
  ```
- No space between function name and `(` when defining or calling.
- Spaces around all binary operators: `$a = $b + $c;`, `$x === $y`.
- Always `===` / `!==` (strict), never `==` / `!=`.
- Trailing comma allowed in multi-line arrays.

## Yoda conditions

Constants and literals on the **left** of comparisons:

```php
if ( true === $is_admin ) { ... }
if ( 'publish' === $post->post_status ) { ... }
if ( null !== $value ) { ... }
```

Prevents accidental assignment (`if ( $x = 5 )`).

## Array syntax

Long form `array()` is the canonical core style; short `[]` is allowed in modern plugins and
WPCS-acceptable. Be consistent within a file.

```php
$args = array(
    'public'      => true,
    'has_archive' => true,
    'supports'    => array( 'title', 'editor' ),
);
```

Align `=>` arrows when it improves readability.

## Strings

- Single quotes when there's no interpolation: `'acme_widgets_version'`.
- Double quotes for interpolation: `"Hello, {$user->display_name}"`.
- For complex output, prefer `sprintf()` with `%s`/`%d` placeholders so translators can reorder.

## PHPDoc

Every function, method, class, and fired hook should have a docblock:

```php
/**
 * Saves a widget setting.
 *
 * @since 1.0.0
 *
 * @param int    $widget_id The widget ID.
 * @param string $value     The new value.
 * @return bool True on success, false on failure.
 */
function acme_widgets_save( $widget_id, $value ) { ... }
```

For filters/actions you fire, document the args:

```php
/**
 * Fires after a widget is saved.
 *
 * @since 1.0.0
 *
 * @param int    $widget_id The widget ID.
 * @param string $value     The saved value.
 */
do_action( 'acme_widgets_after_save', $widget_id, $value );
```

## Tooling

```bash
composer require --dev wp-coding-standards/wpcs dealerdirect/phpcodesniffer-composer-installer
vendor/bin/phpcs  --standard=WordPress src/
vendor/bin/phpcbf --standard=WordPress src/    # auto-fix what's auto-fixable
```

A `phpcs.xml.dist` at the plugin root configures the ruleset, the text domain, and the
prefix allow-list — recommend it for every plugin.

## Common review findings

- Direct file access not guarded (`defined( 'ABSPATH' ) || exit;` missing).
- Functions/classes without prefixes.
- `==` / `!=` instead of `===` / `!==`.
- Missing PHPDoc on public functions.
- Unprefixed hook names.
- Spaces inside parens missing (`if ($foo)` instead of `if ( $foo )`).
- Missing `@since` tags.
