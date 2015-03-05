# FIND

FIND = find $(npm_package_config_find_root) \
-mindepth $(npm_package_config_find_mindepth) \
-maxdepth $(npm_package_config_find_maxdepth) \
-type $(npm_package_config_find_type) \
-name $(npm_package_config_find_name)

# COMMANDS

INSTALL = cd `dirname {}` && $(npm_package_config_task_install)

UNINSTALL = cd `dirname {}` && $(npm_package_config_task_uninstall)

LINK = cd `dirname {}` && $(npm_package_config_task_link)

TEST = cd `dirname {}` && $(npm_package_config_task_test)

PUBLISH = cd `dirname {}` && $(npm_package_config_task_publish)

# TASKS

install:
	$(FIND) -exec sh -c '$(INSTALL)' ';'

uninstall:
	$(FIND) -exec sh -c '$(UNINSTALL)' ';'

link:
	$(FIND) -exec sh -c '$(LINK)' ';'

test:
	$(FIND) -exec sh -c '$(TEST)' ';'

publish:
	$(FIND) -exec sh -c '$(PUBLISH)' ';'

clean:
	find $(npm_package_config_find_root) -xtype l -exec sh -c 'rm -f {}' ';'
	find $(npm_package_config_find_root) -type f -name 'npm-debug.log' -exec sh -c 'rm -f {}' ';'

# TASKLIST

.PHONY: install uninstall link test clean publish
