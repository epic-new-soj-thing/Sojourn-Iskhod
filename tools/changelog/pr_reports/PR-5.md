# PR #5: Scheduled merge

- **Author:** CFWMagic
- **Link:** https://github.com/epic-new-soj-thing/Sojourn-Iskhod/pull/5

## About The Pull Request
<details>
<summary>About The Pull Request</summary>
<hr>

<!-- Describe The Pull Request. -->

<hr>
</details>

## Changelog
```
:cl:
add: Added new cigarette variants in different colors for players to use.  
add: Increased the capacity for injecting cigarettes directly from storage without opening packets.
/:cl:
```

**Changelog entries (included in build):**

- **add:** Increased the capacity for injecting cigarettes directly from storage without opening packets.

<details>
<summary>Files changed</summary>

- `code/game/objects/items/weapons/storage/fancy.dm` (+15 / -0) modified

</details>

<details>
<summary>Diff</summary>

```diff
diff --git a/code/game/objects/items/weapons/storage/fancy.dm b/code/game/objects/items/weapons/storage/fancy.dm
index 1e7dff3a52a..f8a4765b032 100644
--- a/code/game/objects/items/weapons/storage/fancy.dm
+++ b/code/game/objects/items/weapons/storage/fancy.dm
@@ -387,6 +387,21 @@ obj/item/storage/fancy/dogtreats/populate_contents()
 	new /obj/item/clothing/mask/smokable/cigarette/faith/yellow(src)
 	new /obj/item/clothing/mask/smokable/cigarette/faith/green(src)
 	new /obj/item/clothing/mask/smokable/cigarette/faith/orange(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/blue(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/red(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/yellow(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/green(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/orange(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/blue(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/red(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/yellow(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/green(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/orange(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/blue(src)
+	new /obj/item/clothing/mask/smokable/cigarette/faith/red(src)
 	create_reagents(10 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
 
 /obj/item/storage/fancy/cigar

```
</details>
