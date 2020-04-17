// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// Error
  internal static let alertDefaultErrorTile = L10n.tr("Localizable", "alert.default_error_tile")
  /// Information
  internal static let alertDefaultInfoTile = L10n.tr("Localizable", "alert.default_info_tile")
  /// Success
  internal static let alertDefaultSuccessTile = L10n.tr("Localizable", "alert.default_success_tile")
  /// OK
  internal static let commonButtonsOkButtonTitle = L10n.tr("Localizable", "common_buttons.ok_button.title")
  /// Save
  internal static let commonButtonsSaveButtonTitle = L10n.tr("Localizable", "common_buttons.save_button.title")
  /// Details
  internal static let detailsTitle = L10n.tr("Localizable", "details.title")
  /// Item removed from the data base
  internal static let detailsHudSuccessRemoveItemText = L10n.tr("Localizable", "details.hud.success_remove_item.text")
  /// Item saved in the data base
  internal static let detailsHudSuccessSaveItemText = L10n.tr("Localizable", "details.hud.success_save_item.text")
  /// Items loaded!
  internal static let feedHudEndLoadItemsText = L10n.tr("Localizable", "feed.hud.end_load_items.text")
  /// No available item
  internal static let feedHudNoAvailableItemText = L10n.tr("Localizable", "feed.hud.no_available_item.text")
  /// Loading items...
  internal static let feedHudStartLoadItemsText = L10n.tr("Localizable", "feed.hud.start_load_items.text")
  /// There are nobody in category
  internal static let feedPlacheholderNoItemsText = L10n.tr("Localizable", "feed.placheholder.no_items.text")
  /// Saved Items
  internal static let itemsTitle = L10n.tr("Localizable", "items.title")
  /// There are nobody in saved items
  internal static let itemsPlacheholderNoSavedItemsText = L10n.tr("Localizable", "items.placheholder.no_saved_items.text")
  /// Saved Items
  internal static let itemsTabbarTitle = L10n.tr("Localizable", "items.tabbar.title")
  /// Search
  internal static let searchTitle = L10n.tr("Localizable", "search.title")
  /// Submit
  internal static let searchButtonTitle = L10n.tr("Localizable", "search.button.title")
  /// Select a category
  internal static let searchCategoryNameValidationError = L10n.tr("Localizable", "search.category_name.validation_error")
  /// Categories loaded!
  internal static let searchHudEndLoadCategoriesText = L10n.tr("Localizable", "search.hud.end_load_categories.text")
  /// Loading categories...
  internal static let searchHudStartLoadCategoriesText = L10n.tr("Localizable", "search.hud.start_load_categories.text")
  /// Entered Text can't be empty
  internal static let searchKeywordsValidationError = L10n.tr("Localizable", "search.keywords.validation_error")
  /// What are you shopping for?
  internal static let searchPlaceholderText = L10n.tr("Localizable", "search.placeholder.text")
  /// Search
  internal static let searchTabbarTitle = L10n.tr("Localizable", "search.tabbar.title")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
