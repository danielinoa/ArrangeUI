//
//  OverlaySizing.swift
//

import Arrange
import UIKit

/// Shared overlay measurement and clamping behavior for the clamped container views.
@MainActor
enum OverlaySizing {

  static func naturalSize(of subviews: [UIView], insets: UIEdgeInsets = .zero) -> CGSize {
    guard !subviews.isEmpty else { return .zero }
    let contentSize = ZStackLayout().naturalSize(for: subviews).asCGSize
    return adding(insets, to: contentSize)
  }

  static func sizeThatFits(
    _ proposedSize: CGSize,
    subviews: [UIView],
    insets: UIEdgeInsets = .zero
  ) -> CGSize {
    guard !subviews.isEmpty else { return .zero }
    let proposal = normalized(proposedSize)
    let contentProposal = CGSize(
      width: max(proposal.width - insets.left - insets.right, .zero),
      height: max(proposal.height - insets.top - insets.bottom, .zero)
    )
    let contentSize = ZStackLayout()
      .size(fitting: subviews, within: .size(contentProposal.asSize))
      .asCGSize
    return clamped(adding(insets, to: contentSize), to: proposal)
  }

  static func clamped(_ preferredSize: CGSize, to availableSize: CGSize) -> CGSize {
    let preferredSize = normalized(preferredSize)
    let availableSize = normalized(availableSize)
    return .init(
      width: min(preferredSize.width, availableSize.width),
      height: min(preferredSize.height, availableSize.height)
    )
  }

  private static func adding(_ insets: UIEdgeInsets, to size: CGSize) -> CGSize {
    .init(
      width: max(size.width + insets.left + insets.right, .zero),
      height: max(size.height + insets.top + insets.bottom, .zero)
    )
  }

  private static func normalized(_ size: CGSize) -> CGSize {
    .init(width: normalized(size.width), height: normalized(size.height))
  }

  private static func normalized(_ value: CGFloat) -> CGFloat {
    guard !value.isNaN else { return .zero }
    if value == .infinity { return .greatestFiniteMagnitude }
    guard value.isFinite else { return .zero }
    return max(value, .zero)
  }
}
