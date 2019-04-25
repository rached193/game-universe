import { Builder, BuilderConfiguration, BuilderContext, BuildEvent } from '@angular-devkit/architect';
import { WebpackDevServerBuilder } from '@angular-devkit/build-webpack';
import { Observable, of } from 'rxjs';
import { CompileServerBuilderSchema } from './schema';
import { resolve, virtualFs } from '@angular-devkit/core';
import { Stats } from 'fs';

export default class CompileServerBuilder implements Builder<CompileServerBuilderSchema> {
  constructor(private context: BuilderContext) {
  }

  run(builderConfig: BuilderConfiguration<Partial<CompileServerBuilderSchema>>): Observable<BuildEvent> {
    const options = builderConfig.options;
    const root = this.context.workspace.root;
    const projectRoot = resolve(root, builderConfig.root);
    const host = new virtualFs.AliasHost(this.context.host as virtualFs.Host<Stats>);
    const webpackDevServerBuilder = new WebpackDevServerBuilder({ ...this.context, host });


    return of({ success: true });
  }
}
