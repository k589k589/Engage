#!/usr/bin/env python3
"""
generate_xcodeproj.py
Generates a minimal but complete Engage.xcodeproj without any external tools.
Run from the Engage project root:
    python3 generate_xcodeproj.py
"""

import os
import uuid
import glob

# ── Helpers ──────────────────────────────────────────────────────────────────

def xid():
    """Return a 24-char uppercase hex ID used by Xcode."""
    return uuid.uuid4().hex[:24].upper()

# ── Discover source files ─────────────────────────────────────────────────────

ROOT = os.path.dirname(os.path.abspath(__file__))
ENGAGE_DIR = os.path.join(ROOT, "Engage")

swift_files = []
for dirpath, _, filenames in os.walk(ENGAGE_DIR):
    for f in sorted(filenames):
        if f.endswith(".swift"):
            swift_files.append(os.path.join(dirpath, f))

print(f"Found {len(swift_files)} Swift files:")
for p in swift_files:
    print("  ", os.path.relpath(p, ROOT))

# ── IDs ──────────────────────────────────────────────────────────────────────

PROJECT_ID = xid()
TARGET_ID = xid()
BUILD_CONF_LIST_PROJECT = xid()
BUILD_CONF_LIST_TARGET = xid()
DEBUG_CONF_ID = xid()
RELEASE_CONF_ID = xid()
DEBUG_TARGET_CONF_ID = xid()
RELEASE_TARGET_CONF_ID = xid()
SOURCES_PHASE_ID = xid()
FRAMEWORKS_PHASE_ID = xid()
RESOURCES_PHASE_ID = xid()
MAIN_GROUP_ID = xid()
PRODUCTS_GROUP_ID = xid()
SOURCE_GROUP_ID = xid()

# One ID per swift file (for PBXBuildFile + PBXFileReference)
file_ids = { p: (xid(), xid()) for p in swift_files }  # (build_file_id, file_ref_id)

PRODUCT_FILE_REF_ID = xid()

# ── Relative paths from project root ─────────────────────────────────────────

def rel(p):
    return os.path.relpath(p, ROOT)

# ── Build PBXBuildFile section ────────────────────────────────────────────────

def pbx_build_files():
    lines = ["/* Begin PBXBuildFile section */"]
    for p, (bf_id, fr_id) in file_ids.items():
        name = os.path.basename(p)
        lines.append(f"\t\t{bf_id} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fr_id} /* {name} */; }};")
    lines.append("/* End PBXBuildFile section */")
    return "\n".join(lines)

# ── Build PBXFileReference section ───────────────────────────────────────────

def pbx_file_references():
    lines = ["/* Begin PBXFileReference section */"]
    for p, (bf_id, fr_id) in file_ids.items():
        name = os.path.basename(p)
        path = rel(p)
        lines.append(f'\t\t{fr_id} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; name = "{name}"; path = "{path}"; sourceTree = "<group>"; }};')
    lines.append(f'\t\t{PRODUCT_FILE_REF_ID} /* Engage.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = Engage.app; sourceTree = BUILT_PRODUCTS_DIR; }};')
    lines.append("/* End PBXFileReference section */")
    return "\n".join(lines)

# ── Build PBXGroup section ────────────────────────────────────────────────────

def pbx_groups():
    src_children = "\n".join(
        f"\t\t\t\t{fr_id} /* {os.path.basename(p)} */,"
        for p, (_, fr_id) in file_ids.items()
    )
    return f"""/* Begin PBXGroup section */
\t\t{MAIN_GROUP_ID} = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{SOURCE_GROUP_ID} /* Engage */,
\t\t\t\t{PRODUCTS_GROUP_ID} /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{SOURCE_GROUP_ID} /* Engage */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{src_children}
\t\t\t);
\t\t\tname = Engage;
\t\t\tsourceTree = "<group>";
\t\t}};
\t\t{PRODUCTS_GROUP_ID} /* Products */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t{PRODUCT_FILE_REF_ID} /* Engage.app */,
\t\t\t);
\t\t\tname = Products;
\t\t\tsourceTree = "<group>";
\t\t}};
/* End PBXGroup section */"""

# ── Build PBXSourcesBuildPhase ────────────────────────────────────────────────

def pbx_sources_phase():
    files = "\n".join(
        f"\t\t\t\t{bf_id} /* {os.path.basename(p)} in Sources */,"
        for p, (bf_id, _) in file_ids.items()
    )
    return f"""/* Begin PBXSourcesBuildPhase section */
\t\t{SOURCES_PHASE_ID} /* Sources */ = {{
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
{files}
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXSourcesBuildPhase section */"""

# ── Assemble project.pbxproj ──────────────────────────────────────────────────

PBXPROJ = f"""// !$*UTF8*$!
{{
\tarchiveVersion = 1;
\tclasses = {{
\t}};
\tobjectVersion = 56;
\tobjects = {{

{pbx_build_files()}

{pbx_file_references()}

{pbx_groups()}

/* Begin PBXNativeTarget section */
\t\t{TARGET_ID} /* Engage */ = {{
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = {BUILD_CONF_LIST_TARGET} /* Build configuration list for PBXNativeTarget "Engage" */;
\t\t\tbuildPhases = (
\t\t\t\t{SOURCES_PHASE_ID} /* Sources */,
\t\t\t\t{FRAMEWORKS_PHASE_ID} /* Frameworks */,
\t\t\t\t{RESOURCES_PHASE_ID} /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = Engage;
\t\t\tproductName = Engage;
\t\t\tproductReference = {PRODUCT_FILE_REF_ID} /* Engage.app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t}};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t{PROJECT_ID} /* Project object */ = {{
\t\t\tisa = PBXProject;
\t\t\tattributes = {{
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastSwiftUpdateCheck = 1600;
\t\t\t\tLastUpgradeCheck = 1600;
\t\t\t}};
\t\t\tbuildConfigurationList = {BUILD_CONF_LIST_PROJECT} /* Build configuration list for PBXProject "Engage" */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t);
\t\t\tmainGroup = {MAIN_GROUP_ID};
\t\t\tproductsGroup = {PRODUCTS_GROUP_ID} /* Products */;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t{TARGET_ID} /* Engage */,
\t\t\t);
\t\t}};
/* End PBXProject section */

/* Begin PBXFrameworksBuildPhase section */
\t\t{FRAMEWORKS_PHASE_ID} /* Frameworks */ = {{
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXResourcesBuildPhase section */
\t\t{RESOURCES_PHASE_ID} /* Resources */ = {{
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
/* End PBXResourcesBuildPhase section */

{pbx_sources_phase()}

/* Begin XCBuildConfiguration section */
\t\t{DEBUG_CONF_ID} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tENABLE_TESTABILITY = YES;
\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;
\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
\t\t\t\tONLY_ACTIVE_ARCH = YES;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{RELEASE_CONF_ID} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-O";
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t\tVALIDATE_PRODUCT = YES;
\t\t\t}};
\t\t\tname = Release;
\t\t}};
\t\t{DEBUG_TARGET_CONF_ID} /* Debug */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_ASSET_PATHS = "";
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tINFOPLIST_KEY_NSCameraUsageDescription = "Engage uses the camera to capture Instant Life moments.";
\t\t\t\tINFOPLIST_KEY_NSHealthShareUsageDescription = "Engage reads health data to calculate your Vitality score.";
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = UIInterfaceOrientationPortrait;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;
\t\t\t\tLE_SWIFT_VERSION = 6.0;
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.engage.app;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t}};
\t\t\tname = Debug;
\t\t}};
\t\t{RELEASE_TARGET_CONF_ID} /* Release */ = {{
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {{
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_ASSET_PATHS = "";
\t\t\t\tGENERATE_INFOPLIST_FILE = YES;
\t\t\t\tINFOPLIST_KEY_NSCameraUsageDescription = "Engage uses the camera to capture Instant Life moments.";
\t\t\t\tINFOPLIST_KEY_NSHealthShareUsageDescription = "Engage reads health data to calculate your Vitality score.";
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = UIInterfaceOrientationPortrait;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 18.0;
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.engage.app;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t}};
\t\t\tname = Release;
\t\t}};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t{BUILD_CONF_LIST_PROJECT} /* Build configuration list for PBXProject "Engage" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{DEBUG_CONF_ID} /* Debug */,
\t\t\t\t{RELEASE_CONF_ID} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
\t\t{BUILD_CONF_LIST_TARGET} /* Build configuration list for PBXNativeTarget "Engage" */ = {{
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{DEBUG_TARGET_CONF_ID} /* Debug */,
\t\t\t\t{RELEASE_TARGET_CONF_ID} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t}};
/* End XCConfigurationList section */

\t}};
\trootObject = {PROJECT_ID} /* Project object */;
}}
"""

# ── Write files ───────────────────────────────────────────────────────────────

proj_dir = os.path.join(ROOT, "Engage.xcodeproj")
os.makedirs(proj_dir, exist_ok=True)

pbxproj_path = os.path.join(proj_dir, "project.pbxproj")
with open(pbxproj_path, "w") as f:
    f.write(PBXPROJ)

print(f"\n✅ Generated: {pbxproj_path}")
print("   → Open Engage.xcodeproj in Xcode, select an iOS 18 simulator, press ⌘R")
